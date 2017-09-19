package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Serie
import models.SerieModel

@Singleton
class SeriesCtrl @Inject() (implicit exec: ExecutionContext) extends Items[Serie] {
  
  val model = SerieModel
  val colName = "series"

}