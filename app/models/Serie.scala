package models

import play.api.libs.json._

import reactivemongo.bson.BSONObjectID
import play.modules.reactivemongo.json.BSONFormats._

case class Serie (
  _id: Option[BSONObjectID],
  title: String,
  postID: String,
  posteador: String,
  caratula: String,
  capitulo: Option[String],
  temporada: Option[List[String]],
  format: Option[String],
  year: Option[Int],
  calidad: Option[String],
  genero: Option[List[String]],
  idioma: Option[List[String]],
  directores: Option[List[String]],
  reparto: Option[List[String]],
  description: Option[String]
)

object SerieModel extends ItemModel[Serie] {

  val format = Json.format[Serie]

  def searchFields = Map(
        "title" -> SearchField.regex
      , "format" -> SearchField.regex
      , "calidad" -> SearchField.regex
      , "genero" -> SearchField.in
      , "idioma" -> SearchField.in
      , "directores" -> SearchField.in
      , "reparto" -> SearchField.in
  )

}


