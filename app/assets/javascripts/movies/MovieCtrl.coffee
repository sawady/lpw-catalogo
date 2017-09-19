class MovieCtrl

    constructor: (@$log, @MovieService) ->
        @$log.debug "constructing MovieController"
        @service = @MovieService
        @service.initializeService()
        
controllersModule.controller('MovieCtrl', MovieCtrl)