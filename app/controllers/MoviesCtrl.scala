package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Movie
import models.MovieModel

@Singleton
class MoviesCtrl @Inject() (implicit exec: ExecutionContext) extends Items[Movie] {
  
  val model   = MovieModel
  val colName = "movies"

}
