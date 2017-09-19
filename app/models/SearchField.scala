package models

import play.api.libs.json._

object SearchField {

  type FieldTransform = (JsValue, String) => (String, JsValue)

  def regex: FieldTransform = (jsVal, k) => (k, Json.obj("$regex" -> (jsVal \ k).get, "$options" -> "i"))
  def in: FieldTransform = (jsVal, k) => (k, Json.obj("$in" -> (jsVal \ k).get))
  def default: FieldTransform = (jsVal, k) => (k, (jsVal \ k).get)

  def toSearchFields(m: Map[String, FieldTransform]): (JsValue, List[String]) => JsObject = {

    return (jsVal, validKeys) =>
      {

        var ob = Json.obj()

        for (vk <- validKeys) {
          ob = ob + m.getOrElse(vk, default)(jsVal, vk)
        }

        ob
      }

  }


}