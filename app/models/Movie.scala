package models

import play.api.libs.json._
// import reactivemongo.bson.BSONDocumentReader
// import reactivemongo.bson.BSONDocumentWriter
import play.modules.reactivemongo.json.BSONFormats._

import reactivemongo.bson.BSONObjectID

case class Movie (
  _id: Option[BSONObjectID],
  title: String,
  year: Option[Int],
  sinopsis: Option[String],
  idioma: Option[List[String]],
  calidad: Option[String],
  formato: Option[String],
  postID: String,
  posteador: String,
  caratula: String,
  genero: Option[List[String]],
  altTitle: Option[String],
  director: Option[String],
  reparto: Option[List[String]]
) 

object MovieModel extends ItemModel[Movie] {
 
  val format = Json.format[Movie]
  
  private def orAltTitle(validKeys: List[String], ob: JsObject): JsObject = {
    // si tiene titulo lleno tambien busca por alternativo
	  var res = ob
	  if(validKeys.contains("title"))
      {
        val altTit = ob.\("title").get
        val altOb = ob.-("title").+(("altTitle", altTit))
        res = Json.obj("$or" -> Json.toJson(Seq(ob, altOb)))
      }
	  return res
  }
  
  override def toSearchFields = (ob: JsValue, vk: List[String]) => orAltTitle(vk, super.toSearchFields(ob, vk))

  def searchFields = Map(
        "title" -> SearchField.regex
      , "idioma" -> SearchField.in
      , "calidad" -> SearchField.regex
      , "formato" -> SearchField.regex
      , "genero"  -> SearchField.in
      , "altTitle" -> SearchField.regex
      , "director" -> SearchField.regex
      , "reparto"  -> SearchField.in
  )

}