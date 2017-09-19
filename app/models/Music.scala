package models

import play.api.libs.json._

import reactivemongo.bson.BSONObjectID
import play.modules.reactivemongo.json.BSONFormats._

case class Music (
  _id: Option[BSONObjectID],
  title: String,
  year: Option[Int],
  postID: String,
  posteador: String,
  caratula: String,
  tipo: String,
  idioma: Option[List[String]],
  calidad: Option[String],
  genero: Option[List[String]],
  interprete: Option[List[String]],
  description: Option[String]
)

object MusicModel extends ItemModel[Music] {

  val format = Json.format[Music]

  def searchFields = Map(
        "title" -> SearchField.regex
      , "tipo" -> SearchField.regex
      , "idioma" -> SearchField.in
      , "calidad" -> SearchField.regex
      , "interprete" -> SearchField.in
      , "genero" -> SearchField.in
  )
  
}

