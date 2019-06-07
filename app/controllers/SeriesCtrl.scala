package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Serie
import models.SerieModel
import play.api.libs.ws._

import play.modules.reactivemongo.ReactiveMongoApi

@Singleton
class SeriesCtrl @Inject() (val reactiveMongoApi: ReactiveMongoApi, val ws: WSClient) (implicit exec: ExecutionContext) extends Items[Serie] {
  
  val model = SerieModel
  val colName = "series"

}