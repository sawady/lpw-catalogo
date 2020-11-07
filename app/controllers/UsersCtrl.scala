package controllers

import javax.inject._

import scala.concurrent.{ExecutionContext, Future, Promise}
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

import utils.Utils

class UsersCtrl @Inject() (val reactiveMongoApi: ReactiveMongoApi) (implicit exec: ExecutionContext) extends Controller with MongoController with ReactiveMongoComponents {

  def collection: Future[JSONCollection] = reactiveMongoApi.database.map(_.collection[JSONCollection]("users"))

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

  import models._
  import models.User._

  def validateAndThen(jr: JsValue)(block: User => Future[Result]): Future[Result] = {
      // `item` is an instance of their respective case class
      jr.validate[User].map { block(_) }.getOrElse(Future.successful(BadRequest("invalid json")))
  }

  def JsonProcess(block: JsValue => Future[Result]): Action[JsValue] = Action.async(parse.json) {
    request => block(request.body.as[JsValue])
  }

  def JsonProcessValidated(block: User => Future[Result]): Action[JsValue] = JsonProcess {
    request => validateAndThen(Utils.fromWeb(request))(block)
  }

  def deleteUser = Action.async(parse.json) {
    request =>
     collection.flatMap(_.find(request.body.as[JsObject]).one[User]).flatMap(u => 
         u match {
           case None => Future.successful(BadRequest("El usuario no existe"))
           case Some(oldUser) => {
		      collection.flatMap(_.remove(oldUser)).map {
		        lastError =>
		          Ok(s"User Deleted")
		      }
           }
         }
      )
  }

  def changePass = Action.async(parse.json) {
    request =>
      // cambio el id
      val jr = Utils.fromWeb(request.body.as[JsObject])

      jr.validate[UserNewPass].map {
        user =>
          collection.flatMap(_.find(Json.obj(("user", JsString(user.user)), ("pass", JsString(user.pass)))).one[User]).flatMap(u => 
             u match {
               case None => Future.successful(BadRequest("El usuario es inválido"))
               case Some(oldUser) => {
                 collection.flatMap(_.save(User.changePass(oldUser, user.newPass))).map {
                   lastError =>
		              Created(s"User Created")
		         }
               }
             }
          )
      }.getOrElse(Future.successful(BadRequest("Campos inválidos")))
  }
  
  
  def saveUser = Action.async(parse.json) {
    request =>
      // cambio el id
      val jr = Utils.fromWeb(request.body.as[JsObject])

      jr.validate[User].filterNot(user => user.user.isEmpty() || user.role.isEmpty()).map {
        user =>
          collection.flatMap(_.find(Json.obj(("user", JsString(user.user)))).one[User]).flatMap(u => 
             u match {
               case None => collection.flatMap(_.save(user)).map {
				            lastError =>
				              Created(s"User Created")
					        }
               case Some(_) => Future.successful(BadRequest("El usuario ya existe"))
             }  
          )
        // `user` is an instance of the case class `models.User`
      }.getOrElse(Future.successful(BadRequest("Campos inválidos")))
  }

  def modifyUser = JsonProcessValidated {
    user =>
      collection.flatMap(_.save(user)).map {
        lastError =>
          Created(s"User Modified")
      }
  }
  
  def editUser = Action.async(parse.json) {
    request =>
      // cambio el id
      val jr = Utils.fromWeb(request.body.as[JsObject])

      jr.validate[User].filterNot(user => user.user.isEmpty() || user.role.isEmpty()).map {
        user =>
          collection.flatMap(_.find(Json.obj(("user", JsString(user.user)))).one[User]).flatMap(u => 
             u match {
               case None => Future.successful(BadRequest("El usuario no existe"))
               case Some(_) => collection.flatMap(_.save(user)).map {
                  lastError =>
                    Created(s"User Created")
                }
             }
          )
        // `user` is an instance of the case class `models.User`
      }.getOrElse(Future.successful(BadRequest("Campos inválidos")))
  }

  def findUser = Action.async(parse.json) {
    request =>
      val jr = request.body.as[JsObject]
      
      val cursor: Future[Cursor[User]] = collection.map(_.
        find(jr).
        cursor[User])
      
      // everything's ok! Let's reply with the array
      cursor.flatMap(_.headOption.map {
        opUser =>
          opUser match {
            case Some(u) => Ok(Json.obj(("role", JsString(u.role)), ("catalogs", u.catalogs)))
            case None    => Ok(Json.obj(("error", JsString("error"))))
          }
      })
  }

  def findUsers = Action.async(parse.json) {
    request =>
      val jr = request.body.as[JsObject]
      
      val cursor: Future[Cursor[User]] = collection.map(_.
        find(jr).
        cursor[User])

      // gather all the JsObjects in a list
      val futureList: Future[List[JsValue]] = cursor.flatMap(_.collect[List]().map { xs =>
        xs.map { mv =>
          Utils.toWeb(Json.toJson(mv))
        }
      })

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
