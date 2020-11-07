name := """lpw-catalogo"""

version := "1.0-SNAPSHOT"

val reactiveMongoVer = "0.11.14"

lazy val root = (project in file(".")).enablePlugins(PlayScala)

scalaVersion := "2.11.11"

libraryDependencies += jdbc
libraryDependencies += cache
libraryDependencies += ws
libraryDependencies += "org.scalatestplus.play" %% "scalatestplus-play" % "2.0.0" % Test

// only for Play 2.5.x
libraryDependencies += "org.reactivemongo" %% "play2-reactivemongo" % reactiveMongoVer


