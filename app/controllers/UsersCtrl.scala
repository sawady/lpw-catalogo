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

  def collection: JSONCollection = db.collection[JSONCollection]("users")

  // ------------------------------------------ //
  // Using case classes + Json Writes and Reads //
  // ------------------------------------------ //

  import models._
  import models.User._

  implicit val userWrite = Json.writes[User]

  def deleteUser = Action.async(parse.json) {
    request =>
     collection.find(request.body.as[JsObject]).one[User].flatMap(u => 
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
      val jr = Utils.fromWeb(request.body.as[JsObject])

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
      val jr = Utils.fromWeb(request.body.as[JsObject])

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
      val jr = request.body.as[JsObject]
      
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

}
