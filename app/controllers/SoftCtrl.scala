package controllers

import javax.inject._
import scala.concurrent.ExecutionContext
import models.Soft
import models.SoftModel

@Singleton
class SoftCtrl @Inject() (implicit exec: ExecutionContext) extends Items[Soft] {
  
  val model = SoftModel
  val colName = "soft"

}