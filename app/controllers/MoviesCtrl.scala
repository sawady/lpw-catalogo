package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Movie
import models.MovieModel
import play.api.libs.ws._

import play.modules.reactivemongo.ReactiveMongoApi

@Singleton
class MoviesCtrl @Inject() (val reactiveMongoApi: ReactiveMongoApi, val ws: WSClient) (implicit exec: ExecutionContext) extends Items[Movie] {
  
  val model   = MovieModel
  val colName = "movies"

}
