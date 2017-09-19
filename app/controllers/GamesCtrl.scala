package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Game
import models.GameModel

import play.modules.reactivemongo.ReactiveMongoApi

@Singleton
class GamesCtrl @Inject() (val reactiveMongoApi: ReactiveMongoApi) (implicit exec: ExecutionContext) extends Items[Game] {
  
  val model = GameModel
  val colName = "games"

}