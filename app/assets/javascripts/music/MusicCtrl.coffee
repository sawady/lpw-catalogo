class MusicCtrl

    constructor: (@$log, @MusicService) ->
        @$log.debug "constructing MusicController"
        @service = @MusicService
        @service.initializeService()
        
controllersModule.controller('MusicCtrl', MusicCtrl)