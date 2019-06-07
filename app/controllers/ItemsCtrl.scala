package controllers

import javax.inject._

import scala.concurrent.{ExecutionContext, Future, Promise}
import scala.util.{Failure, Success}
import scala.concurrent.duration._

import play.api._
import play.api.mvc._
import play.api.libs.json._

import play.modules.reactivemongo.json.collection._
import play.modules.reactivemongo.{
  MongoController,
  ReactiveMongoApi,
  ReactiveMongoComponents
}

// BSON-JSON conversions/collection
import reactivemongo.play.json._
import reactivemongo.api.Cursor
import reactivemongo.core.commands.Count
import reactivemongo.api.QueryOpts

import reactivemongo.bson.{BSONDocument, BSONObjectID}

/*
import play.api.libs.json.Json
import play.api.libs.json.Json.toJsFieldJsValueWrapper
import play.modules.reactivemongo.json.ImplicitBSONHandlers
import play.modules.reactivemongo.json.collection.JSONCollection
*/

import models.ItemModel
import utils.Utils

abstract class Items[T] (implicit exec: ExecutionContext) extends Controller with MongoController with ReactiveMongoComponents  {
  
  val model: ItemModel[T]
  val colName: String
  
  implicit lazy val format: Format[T] = model.format
  
  /*
   * Get a JSONCollection (a Collection implementation that is designed to work
   * with JsObject, Reads and Writes.)
   * Note that the `collection` is not a `val`, but a `def`. We do _not_ store
   * the collection reference to avoid potential problems in development with
   * Play hot-reloading.
   */
  
  def collection: JSONCollection = db.collection[JSONCollection](colName)
  
  def JsonProcess(block: JsValue => Future[Result]): Action[JsValue] = Action.async(parse.json) {
    request => block(request.body.as[JsValue])
  }
  
  def JsonProcessValidated(block: T => Future[Result]): Action[JsValue] = JsonProcess {
    request => validateAndThen(Utils.fromWeb(request))(block)
  }
  
  def validateAndThen(jr: JsValue)(block: T => Future[Result]): Future[Result] = {
      // `item` is an instance of their respective case class
      jr.validate[T].map { block(_) }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

  def delete = JsonProcess {
    request =>
      val jr = Utils.fromWeb(request)
      collection.remove(Utils.getId(jr).as[JsObject]).map {
        lastError =>
          Ok(s"Item Deleted")
      }
  }

  def save = JsonProcessValidated {
    item =>
      collection.save(item).map {
        lastError =>
          Created(s"Item Created")
      }
  }

  def countLike() = JsonProcess { jr =>
    val search = jr.\("search").get
    val validKeys = jr.\("validKeys").as[List[String]]
    
    val obj = model.toSearchFields(search, validKeys)

    val req = ImplicitBSONHandlers.JsObjectWriter.write(model.toSearchFields(search, validKeys))

    collection.db.command(Count(collection.name, Some(req))).map { count =>
      Ok(Json.obj("count" -> count))
    }
  }

  def get(id: String) = Action.async {
    BSONObjectID.parse(id).map { 
      objId =>
        val future = collection.find(BSONDocument("_id" -> objId)).one[T]
        future.map {
          option => option match {
              case Some(doc) => Ok(Utils.toWeb(Json.toJson(doc)))
              case None => Ok(Json.obj())
          }
        }
    } getOrElse(Future.successful(Ok(Json.obj())))
  }
  
  def find = JsonProcess {
    jr =>
      val search = jr.\("search")
      val validKeys = jr.\("validKeys").as[List[String]]
      val currentPage = jr.\("page").as[Int]
      findLike(model.toSearchFields(search.get, validKeys), currentPage)
  }

  def findLike(jsobj: JsObject, pageNumber: Int) = {
    val numberPerPage = 8

    val cursor: Cursor[T] = collection.
      // find all
      find(jsobj).
      // sort them by creation date
      sort(Json.obj("$natural" -> -1)).
      // skip based on pageNumber
      options(QueryOpts((pageNumber - 1) * numberPerPage, numberPerPage)).
      // perform the query and get a cursor of JsObject
      cursor[T]

    // gather all the JsObjects in a list
    val futureList: Future[List[JsValue]] = cursor.collect[List](numberPerPage).map { xs =>
      xs.map { mv =>
        Utils.toWeb(Json.toJson(mv))
      }
    }

    // transform the list into a JsArray
    val futureJsonArray: Future[JsArray] = futureList.map { items =>
      Json.arr(items)
    }

    // everything's ok! Let's reply with the array
    futureJsonArray.map {
      items =>
        Ok(items(0).get)
    }

  }

}
