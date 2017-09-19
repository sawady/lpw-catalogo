class SerieCtrl

    constructor: (@$log, @SerieService) ->
        @$log.debug "constructing SerieController"
        @service = @SerieService
        @service.initializeService()
        
controllersModule.controller('SerieCtrl', SerieCtrl)