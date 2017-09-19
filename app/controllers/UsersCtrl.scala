package controllers

import akka.actor.ActorSystem
import javax.inject._
import play.api._
import play.api.mvc._
import scala.concurrent.{ExecutionContext, Future, Promise}
import scala.concurrent.duration._

/*
import play.modules.reactivemongo.MongoController
import play.modules.reactivemongo.json.BSONFormats._
import play.modules.reactivemongo.json.ImplicitBSONHandlers
import play.modules.reactivemongo.json.collection.JSONCollection
import reactivemongo.api.Cursor
import reactivemongo.api.QueryOpts
import reactivemongo.bson.BSONDocument
import reactivemongo.core.commands.Count
*/
import utils.Utils

class UsersCtrl @Inject() (implicit exec: ExecutionContext) extends Controller {

  // def collection: JSONCollection = db.collection[JSONCollection]("users")

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

  import models._
  import models.User._

  /*

  def deleteUser = Action.async(parse.json) {
    request =>
     collection.find(request.body.as[JsValue]).one[User].flatMap(u => 
         u match {
           case None => Future.successful(BadRequest("El usuario no existe"))
           case Some(oldUser) => {
		      collection.remove(oldUser).map {
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
      val jr = Utils.fromWeb(request.body.as[JsValue])

      jr.validate[UserNewPass].map {
        user =>
          collection.find(Json.obj(("user", JsString(user.user)), ("pass", JsString(user.pass)))).one[User].flatMap(u => 
             u match {
               case None => Future.successful(BadRequest("El usuario es inválido"))
               case Some(oldUser) => {
                 collection.save(User.changePass(oldUser, user.newPass)).map {
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
      val jr = Utils.fromWeb(request.body.as[JsValue])

      jr.validate[User].filterNot(user => user.user.isEmpty() || user.role.isEmpty() || user.role.isEmpty()).map {
        user =>
          collection.find(Json.obj(("user", JsString(user.user)))).one[User].flatMap(u => 
             u match {
               case None => collection.save(user).map {
				            lastError =>
				              Created(s"User Created")
					        }
               case Some(_) => Future.successful(BadRequest("El usuario ya existe"))
             }  
          )
        // `user` is an instance of the case class `models.User`
      }.getOrElse(Future.successful(BadRequest("Campos inválidos")))
  }
  
  def findUser = Action.async(parse.json) {
    request =>
      val jr = request.body.as[JsValue]
      
      val cursor: Cursor[User] = collection.
        find(jr).
        cursor[User]
      
      // everything's ok! Let's reply with the array
      cursor.headOption.map {
        opUser =>
          opUser match {
            case Some(u) => Ok(Json.obj(("role", JsString(u.role)), ("catalogs", u.catalogs)))
            case None    => Ok(Json.obj(("error", JsString("error"))))
          }
      }
  }

  */

}
