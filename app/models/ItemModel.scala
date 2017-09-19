package models

import play.api.libs.json.Format

trait ItemModel[T] extends WithSearchFields {
  
  val format: Format[T]

}