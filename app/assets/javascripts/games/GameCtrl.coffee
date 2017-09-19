class GameCtrl

    constructor: (@$log, @GameService) ->
        @$log.debug "constructing GameController"
        @service = @GameService
        @service.initializeService()
        
controllersModule.controller('GameCtrl', GameCtrl)