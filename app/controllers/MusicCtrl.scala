package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Music
import models.MusicModel

@Singleton
class MusicCtrl @Inject() (implicit exec: ExecutionContext) extends Items[Music] {
  
  val model = MusicModel
  val colName = "music"

}