package utils


import play.api.libs.json._

object Utils {

 
  def getId(js: JsValue): JsValue = {
    val tr = (__ \ '_id).json.pickBranch
    return js.transform(tr).get
  }

  def fromWeb(js: JsValue): JsValue = {
    val tr = (__ \ '_id).json.update(
      __.read[String].map { v => JsObject(("$oid", JsString(v)) +: Nil) })

    return js.transform(tr).asOpt match {
      case Some(js2) => js2
      case None => js
    }
  }

  def toWeb(js: JsValue): JsValue = {
    val picId = js.transform((__ \ '_id \ '$oid).json.pick).get

    val tr = (__ \ '_id).json.update(
      __.read[JsValue].map { v => picId })

    return js.transform(tr).get
  }


}