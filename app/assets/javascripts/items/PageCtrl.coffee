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

    getMaxPages: () ->
        size = document.querySelectorAll(".main-items-container")[0].clientWidth
        if size < 480
           return 3
        if size < 580
           return 5
        return 10

class PageService

    constructor: (@$log) ->
        @$log.debug "constructing PageService"
        
    newPageCtrl: (service) ->
        return new PageCtrl(@$log, service)
        
servicesModule.service('PageService', PageService)