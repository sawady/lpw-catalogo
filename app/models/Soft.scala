package models

import play.api.libs.json._

import reactivemongo.bson.BSONObjectID
import play.modules.reactivemongo.json.BSONFormats._

case class Soft (
  _id: Option[BSONObjectID],
  title: String,
  postID: String,
  posteador: String,
  caratula: String,
  tipo: String,
  platform: String,
  year: Option[Int],
  format: Option[String],
  developer: Option[String],
  idioma: Option[List[String]],
  requirements: Option[String],
  description: Option[String]
)

object SoftModel extends ItemModel[Soft] {
  
  val format = Json.format[Soft]
  
  def searchFields = Map(
        "title" -> SearchField.regex
      , "tipo" -> SearchField.regex
      , "platform" -> SearchField.regex
      , "format" -> SearchField.regex
      , "developer" -> SearchField.regex
      , "idioma" -> SearchField.in
      , "requirements" -> SearchField.regex
  )
  
}