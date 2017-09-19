class SoftCtrl

    constructor: (@$log, @SoftService) ->
        @$log.debug "constructing SoftController"
        @service = @SoftService
        @service.initializeService()
        
controllersModule.controller('SoftCtrl', SoftCtrl)