package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Game
import models.GameModel

@Singleton
class GamesCtrl @Inject() (implicit exec: ExecutionContext) extends Items[Game] {
  
  val model = GameModel
  val colName = "games"

}