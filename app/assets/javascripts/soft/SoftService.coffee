
class SoftService

    constructor: (@$log, @$location, @OptionCtrl, @ItemService, @$modal, @UsersService, @PageService) ->
        @$log.debug "constructing SoftService"
        
        @search  = {}
        @results = []
        @selectedItem = {}
        
        @marco = "marco_soft.png"
        
        @totalItems = 0
        
        @tipoDefault = ["Sistema Operativo", "Mantenimiento", "AntiVirus", "Utilitario", "Oficina", "Edición de imágenes", "Edición de videos", "Edición de sonido", "Reproductor multimedia", "Aplicación", "Temas"]
        @platformDefault = ["PC Linux", "PC Windows", "Multiplataforma", "MAC", "Android", "IPHONE", "Windows Phone"]
        @formatDefault = ["Portable", "EXE Instalable", "ISO BR", "ISO DVD", "ISO CD", "APK"]
        @idiomaDefaut = ['Español', 'Inglés', 'Multilenguaje']
        @requirementsDefault = ["Bajos", "Medio bajos", "Medio altos", "Altos"]
        
        @tipo         = @OptionCtrl.newSingleModel('Tipo', @tipoDefault)
        @platform     = @OptionCtrl.newSingleModel('Plataforma', @platformDefault)
        @format       = @OptionCtrl.newSingleModel('Formato', @formatDefault)
        @idioma       = @OptionCtrl.newManyModel('Idioma', @idiomaDefaut)
        @requirements = @OptionCtrl.newSingleModel('Requisitos', @requirementsDefault)
		
        @panelesDeOpciones = [@tipo, @platform, @format, @idioma, @requirements]

    view: () ->
        @ItemService.viewSoft()
                
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
               @$log.error "Unable to get soft: #{error}"
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
       @search.platform = @platform.getSelected()
       @search.format = @format.getSelected()
       @search.idioma = @idioma.getSelected()
       @search.requirements = @requirements.getSelected()
        
    getItems: (aPage = 1) ->
       @$log.debug "getAllSoft() like #{angular.toJson(@search)}"
       
       @pageCtrl.setPage(aPage)
       @setInfoFromOptionPanels()
       
       @ItemService.filterNullProps(@search)

       toDB =
            search: @search
            validKeys: Object.keys(@search)
            page: aPage
       
       @countSoft(toDB)
					
       @ItemService.list(toDB)
              .then(
                   (data) =>
                      @$log.debug "Promise returned #{data.length} Soft"
                      @results = data
                   ,
                   (error) =>
                      @$log.error "Unable to get Soft: #{error}"
                      @search  = {}
                      @results = []
                   )

    countSoft: (toDB) ->
       @ItemService.count(toDB)
       .then(
             (data) =>
               @$log.debug "There are #{data.count} soft in total"
               @totalItems = data.count
             ,
             (error) =>
               @$log.error "Unable to get count of Soft: #{error}"
       )
       
    save: (item) ->
       @ItemService.save(item)
       .then(
           (data) =>
               @$log.debug "Promise returned #{data} Soft"
               @$location.path("/soft")
           ,
           (error) =>
               @$log.error "Unable to create soft: #{error}"
           )
       
    puedeBorrar: () ->
       @UsersService.isAdmin()
       
    puedeAgregar: () ->
       @UsersService.isUploader("soft")
       
    puedeEditar: (item) ->
       @UsersService.isUploader("soft", item)

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

servicesModule.service('SoftService', SoftService)