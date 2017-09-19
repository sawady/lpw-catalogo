package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Music
import models.MusicModel

import play.modules.reactivemongo.ReactiveMongoApi

@Singleton
class MusicCtrl @Inject() (val reactiveMongoApi: ReactiveMongoApi) (implicit exec: ExecutionContext) extends Items[Music] {
  
  val model = MusicModel
  val colName = "music"

}