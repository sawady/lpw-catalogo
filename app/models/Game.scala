package models

import play.api.libs.json._

/*
import reactivemongo.bson.BSONObjectID
import play.modules.reactivemongo.json.BSONFormats._
*/

case class Game (
//  _id: Option[BSONObjectID],
  title: String,
  year: Int,
  postID: String,
  posteador: String,
  caratula: String,
  platform: String,
  format: Option[String],
  developer: Option[String],
  pegi: Option[Int],
  audio: Option[List[String]],
  text: Option[List[String]],
  genero: Option[List[String]],
  distribuidor: Option[String],
  requirements: Option[String],
  sinopsis: Option[String]
)

object GameModel extends ItemModel[Game] {
  
  val format = Json.format[Game]

  def searchFields = Map(
        "title" -> SearchField.regex
      , "audio" -> SearchField.in
      , "text" -> SearchField.in
      , "plataform" -> SearchField.regex
      , "format" -> SearchField.regex
      , "genero" -> SearchField.in
      , "developer" -> SearchField.regex
      , "distribuidor" -> SearchField.regex
  )

}