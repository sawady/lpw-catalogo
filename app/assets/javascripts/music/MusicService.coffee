
class MusicService

    constructor: (@$log, @$location, @OptionCtrl, @ItemService, @$modal, @UsersService, @PageService, @$route) ->
        @$log.debug "constructing MusicService"
        
        @newSearch()

        @results = []
        @selectedItem = {}
        
        @marco = "marco_music.png"
        
        @totalItems = 0
        
        @tipoDefault = ["Discografía", "Album", "Recital", "Documental", "Video", "Tema suelto", "OST"]
        @idiomaDefault = ["Español", "Inglés", "Japonés", "Alemán", "Francés", "Portugués"]
        @calidadDefault = ["DVD", "BluRay", "M4A", "FLAC", "192 Lbps", "200 Kbps", "320 Kbps", "AVI", "MP3", "MP4", "MKV", "Variada"]
        @generoDefault = ["Bachata", "Blues", "Clasica" , "Cumbia" , "Electronica" , "Folclore" , "Glam rock" , "Gregoriana" , "Hard Rock" , "Infantil" , "Instrumental" , "Jazz" , "Metal" , "Música disco" , "Musical" , "New Age" , "Opera" , "Pop" , "Rap - Hip Hop" , "Recopilación", "Regaee" , "Reggaeton" , "Rock" , "Rock Alternativo" , "Rock Castellano" , "Rock progresivo" , "Ska" , "Tango"]

        @tipo         = @OptionCtrl.newSingleModel('Tipo', @tipoDefault)
        @idioma       = @OptionCtrl.newManyModel('Idioma', @idiomaDefault)
        @calidad      = @OptionCtrl.newSingleModel('Calidad', @calidadDefault)
        @genero       = @OptionCtrl.newManyModel('Genero', @generoDefault)
        @interprete   = @OptionCtrl.newManyModel('Interprete', [])

        @panelesDeOpciones = [@tipo, @idioma, @calidad, @genero, @interprete]

    newSearch: () ->
        @search  = {
           posteador: @$route.current.params.posteador
        }

    view: () ->
        @ItemService.initializeFor("music")
                
    initializeService: () ->
        @view()
        @pageCtrl = @PageService.newPageCtrl(this)
        @getItems()
        
    thereAreItems: () ->
        return @results.length > 0

    resetSearch: () ->
        @newSearch()
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
               @$log.error "Unable to get music: #{error}"
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
       @search.tipo = @tipo.getSelected()
       @search.idioma = @idioma.getSelected()
       @search.calidad = @calidad.getSelected()
       @search.genero = @genero.getSelected()
       @search.interprete = @interprete.getSelected()
        
    getItems: (aPage = 1) ->
       @$log.debug "getAllMusic() like #{angular.toJson(@search)}"
       
       @pageCtrl.setPage(aPage)
       @setInfoFromOptionPanels()
       
       @ItemService.filterNullProps(@search)

       toDB =
            search: @search
            validKeys: Object.keys(@search)
            page: aPage
       
       @countMusic(toDB)
					
       @ItemService.list(toDB)
              .then(
                   (data) =>
                      @$log.debug "Promise returned #{data.length} Music"
                      @results = data
                   ,
                   (error) =>
                      @$log.error "Unable to get Music: #{error}"
                      @search  = {}
                      @results = []
                   )

    countMusic: (toDB) ->
       @ItemService.count(toDB)
       .then(
             (data) =>
               @$log.debug "There are #{data.count} music in total"
               @totalItems = data.count
             ,
             (error) =>
               @$log.error "Unable to get count of Music: #{error}"
       )
       
    save: (item) ->
       @ItemService.save(item)
       .then(
           (data) =>
               @$log.debug "Promise returned #{data} Music"
               @$location.path("/music")
           ,
           (error) =>
               @$log.error "Unable to create Music: #{error}"
           )
       
    puedeBorrar: () ->
       @UsersService.isAdmin()
       
    puedeAgregar: () ->
       @UsersService.isUploader("music")
       
    puedeEditar: (item) ->
       @UsersService.isUploader("music", item)
        
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

    hasLang: (m, lang) ->
       if lang
          return lang in m.idioma
       else
          return m.idioma

servicesModule.service('MusicService', MusicService)