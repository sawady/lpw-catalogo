
class SerieService

    constructor: (@$log, @$location, @OptionCtrl, @ItemService, @$modal, @UsersService, @PageService) ->
        @$log.debug "constructing SerieService"
        
        @search  = {}
        @results = []
        @selectedItem = {}
        
        @marco = "marco_series.png"
        
        @totalItems = 0
        
        @capituloDefault = ["1", "2", "3", "4", "Temporada completa"]
        @temporadaDefault = ["1", "2", "3", "4", "Serie completa"]
        @formatDefault = ['AVI', 'MP4', 'MKV', 'MT2', 'ISO']
        @calidadDefault = ['DVD FULL', 'DVD-Rip', 'BR-Rip', '720p', '1080p']
        @generoDefault = ['Acción', 'Anime', 'Aventura', 'Bélica', 'Ciencia Ficción', 'Comedia', 'Documental', 'Drama', 'Fantástico', 'Infantil', 'Intriga', 'Musical', 'Policial', 'Romántica', 'Suspenso', 'Terror', 'Thriller', 'Western']
        @idiomaDefault = ['Latino', 'Español', 'Inglés', 'Japonés', 'Francés', 'Portugués', 'Subtitulada']
        
        @capitulo     = @OptionCtrl.newSingleModel('Capítulo', @capituloDefault)
        @temporada    = @OptionCtrl.newManyModel('Temporada', @temporadaDefault)
        @format       = @OptionCtrl.newSingleModel('Formato', @formatDefault)
        @calidad      = @OptionCtrl.newSingleModel('Calidad', @calidadDefault)
        @genero       = @OptionCtrl.newManyModel('Género', @generoDefault)
        @idioma       = @OptionCtrl.newManyModel('Idioma', @idiomaDefault)
        @directores   = @OptionCtrl.newManyModel('Directores', [])
        @reparto      = @OptionCtrl.newManyModel('Reparto', [])
		
        @panelesDeOpciones = [@temporada, @format, @calidad, @genero, @directores, @reparto, @idioma]

    view: () ->
        @ItemService.viewSeries()
                
    initializeService: () ->
        @view()
        @pageCtrl = @PageService.newPageCtrl(this)
        @getItems()
        
    thereAreItems: () ->
        return @results.length > 0

    resetSearch: () ->
        @search = {}
        p.reset() for p in @panelesDeOpciones
        @pageCtrl.setPage(1)

    createItem: () ->
        @selectedItem = {}
        @ItemService.createForm()

    updateItem: (item) ->
        @selectedItem = item
        @ItemService.updateForm()

    cloneItem: (item) ->
        @selectedItem = Object.assign({}, item)
        @selectedItem._id = undefined
        @ItemService.updateForm()

    getFromLPW: (id) ->
       @ItemService.get(id)
       .then(
             (data) =>
               @selectedItem = Object.assign({}, data)
             ,
             (error) =>
               @$log.error "Unable to get series: #{error}"
       )

    deleteItem: (item) ->
        @ItemService.delete(item)
              .then(
                   (data) =>
                      @getItems()
                   ,
                   (error) =>
                      @$log.error "Unable to delete #{error}"
                   )

    setInfoFromOptionPanels: () ->
       @search.capitulo = @capitulo.getSelected()
       @search.temporada = @temporada.getSelected()
       @search.format = @format.getSelected()
       @search.calidad = @calidad.getSelected()
       @search.genero = @genero.getSelected()
       @search.directores = @directores.getSelected()
       @search.reparto = @reparto.getSelected()
       @search.idioma = @idioma.getSelected()
        
    getItems: (aPage = 1) ->
       @$log.debug "getAllSeries() like #{angular.toJson(@search)}"
       
       @pageCtrl.setPage(aPage)
       @setInfoFromOptionPanels()
       
       @ItemService.filterNullProps(@search)

       toDB =
            search: @search
            validKeys: Object.keys(@search)
            page: aPage
       
       @countSeries(toDB)
					
       @ItemService.list(toDB)
              .then(
                   (data) =>
                      @$log.debug "Promise returned #{data.length} Series"
                      @results = data
                   ,
                   (error) =>
                      @$log.error "Unable to get Series: #{error}"
                      @search  = {}
                      @results = []
                   )

    countSeries: (toDB) ->
       @ItemService.count(toDB)
       .then(
             (data) =>
               @$log.debug "There are #{data.count} series in total"
               @totalItems = data.count
             ,
             (error) =>
               @$log.error "Unable to get count of Series: #{error}"
       )
       
    save: (item) ->
       @ItemService.save(item)
       .then(
           (data) =>
               @$log.debug "Promise returned #{data} Serie"
               @$location.path("/series")
           ,
           (error) =>
               @$log.error "Unable to create Serie: #{error}"
           )
       
    puedeBorrar: () ->
       @UsersService.isAdmin()
       
    puedeAgregar: () ->
       @UsersService.isUploader("series")
       
    puedeEditar: (item) ->
       @UsersService.isUploader("series", item)

    puedeBuscarPost: () ->
       !@UsersService.isInvitado()
        
    openOnDelete: (item) ->
    
      modalCtrl = ($scope, $modalInstance, item) ->
          $scope.item = item
          
          $scope.ok = () ->
              $modalInstance.close(true)

          $scope.cancel = () ->
              $modalInstance.dismiss(false)
    
      modalInstance = @$modal.open(
          templateUrl: '/assets/partials/modals/onDeleteModal.html'
          controller: modalCtrl
          item: item
          resolve: 
             item: () -> item
      )
                    
      loggg  = @$log
      m = this
      
      onOk = (answer) -> 
                 loggg.info('Accepted deletion') if answer
                 m.deleteItem(item)
        
      onOther = () -> loggg.info('Modal dismissed at: ' + new Date())
       
      modalInstance.result.then(onOk, onOther)

servicesModule.service('SerieService', SerieService)