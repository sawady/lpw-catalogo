
class GameService

    constructor: (@$log, @$location, @OptionCtrl, @ItemService, @$modal, @UsersService, @PageService, @$route) ->
        @$log.debug "constructing GameService"
        
        @newSearch()

        @results = []
        @selectedItem = {}
        
        @marco = "marco_games.png"
        
        @totalItems = 0
        
        @formatDefault = ["Portable", "EXE Instalable", "ROM", "ISO BR", "ISO DVD 5", "ISO DVD 9", "CD"]
        @platformDefault = ["PC", "Ps1", "Ps2", "Ps3", "Ps4", "Xbox", "Xbox one"]
        @audioDefault = ['Español', 'Inglés', 'Japonés', 'Multilenguaje']
        @textDefault  = ['Español', 'Inglés', 'Japonés', 'Multilenguaje']
        @generoDefault = ["Abandonware", "Acción", "Arcade", "Aventura", "Aventura Gráfica", "Carreras", "Deportes", "Estrategia", "Indie", "Naves", "Peleas", "Plataforma", "Puzzle", "RPG en tiempo real", "RPG táctico", "Shooter"]
        @requirementsDefault = ["Bajos", "Medio bajos", "Medio altos", "Altos"]

        @format       = @OptionCtrl.newSingleModel('Formato', @formatDefault)
        @platform     = @OptionCtrl.newSingleModel('Plataforma', @platformDefault)
        @audio        = @OptionCtrl.newManyModel('Audio', @audioDefault)
        @text         = @OptionCtrl.newManyModel('Texto', @textDefault)
        @genero       = @OptionCtrl.newManyModel('Genero', @generoDefault)
        @requirements = @OptionCtrl.newSingleModel('Requisitos', @requirementsDefault)
		
        @panelesDeOpciones = [@format, @platform, @audio, @text, @genero, @requirements]

    newSearch: () ->
        @search  = {
           posteador: @$route.current.params.posteador
        }

    view: () ->
        @ItemService.initializeFor("games")
                
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
               @$log.error "Unable to get game: #{error}"
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
       @search.format = @format.getSelected()
       @search.platform = @platform.getSelected()
       @search.audio = @audio.getSelected()
       @search.text = @text.getSelected()
       @search.genero = @genero.getSelected()
       @search.requirements = @requirements.getSelected()
        
    getItems: (aPage = 1) ->
       @$log.debug "getAllGames() like #{angular.toJson(@search)}"
       
       @pageCtrl.setPage(aPage)
       @setInfoFromOptionPanels()
       
       @ItemService.filterNullProps(@search)

       toDB =
            search: @search
            validKeys: Object.keys(@search)
            page: aPage
       
       @countGames(toDB)
					
       @ItemService.list(toDB)
              .then(
                   (data) =>
                      @$log.debug "Promise returned #{data.length} Games"
                      @results = data
                   ,
                   (error) =>
                      @$log.error "Unable to get Games: #{error}"
                      @search  = {}
                      @results = []
                   )

    countGames: (toDB) ->
       @ItemService.count(toDB)
       .then(
             (data) =>
               @$log.debug "There are #{data.count} games in total"
               @totalItems = data.count
             ,
             (error) =>
               @$log.error "Unable to get count of Games: #{error}"
       )
       
    save: (item) ->
       @ItemService.save(item)
       .then(
           (data) =>
               @$log.debug "Promise returned #{data} Game"
               @$location.path("/games")
           ,
           (error) =>
               @$log.error "Unable to create Game: #{error}"
           )
       
    puedeBorrar: () ->
       @UsersService.isAdmin()
       
    puedeAgregar: () ->
       @UsersService.isUploader("games")
       
    puedeEditar: (item) ->
       @UsersService.isUploader("games", item)

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

servicesModule.service('GameService', GameService)