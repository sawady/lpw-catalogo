class PageCtrl

    constructor: (@$log, @service) ->
        @currentPage = 1
        
    setPage: (pageNo) ->
       @currentPage = pageNo
            
    pageChanged: () ->
        @$log.debug("Page changed to:" + @currentPage)
        @service.getItems(@currentPage)
    
    getTotalItems: () ->
        return @service.totalItems
    
    thereAreItems: () ->
        return @service.thereAreItems()
        
    getResults: () ->
        return @service.getResults()

class PageService

    constructor: (@$log) ->
        @$log.debug "constructing PageService"
        
    newPageCtrl: (service) ->
        return new PageCtrl(@$log, service)
        
servicesModule.service('PageService', PageService)