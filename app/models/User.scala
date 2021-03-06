package models

import play.api.libs.json._

import reactivemongo.bson.BSONObjectID
import play.modules.reactivemongo.json.BSONFormats._

case class User(
  _id: Option[BSONObjectID],
  user: String,
  pass: String,
  role: String,
  catalogs: Option[List[String]]
)

case class UserNewPass(
  user: String,
  pass: String,
  newPass: String
)

object User {

  implicit val format = Json.format[User]
  implicit val formatPass = Json.format[UserNewPass]

  def changePass(user: User, newPass: String): User = {
    return User(user._id, user.user, newPass, user.role, user.catalogs)
  }

}