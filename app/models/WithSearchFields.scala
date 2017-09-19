package models

trait WithSearchFields {

  def searchFields: Map[String, SearchField.FieldTransform]

  def toSearchFields = SearchField.toSearchFields(searchFields)

}