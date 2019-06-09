
class SaveSerieCtrl

    constructor: (@$log, @OptionCtrl, @SerieService) ->
       @$log.debug "constructing SaveSerieController"
       
       @item = @SerieService.selectedItem
       @SerieService.view()

       @capitulo     = @OptionCtrl.newSingleModel('Capítulo (Opcional)', @SerieService.capituloDefault)
       @temporada    = @OptionCtrl.newManyModel('Temporada', @SerieService.temporadaDefault)
       @format       = @OptionCtrl.newSingleModel('Formato (Opcional)', @SerieService.formatDefault)
       @calidad      = @OptionCtrl.newSingleModel('Calidad (Opcional)', @SerieService.calidadDefault)
       @genero       = @OptionCtrl.newManyModel('Género (Opcional)', @SerieService.generoDefault)
       @idioma       = @OptionCtrl.newManyModel('Idioma (Opcional)', @SerieService.idiomaDefault)
       @directores   = @OptionCtrl.newManyModel('Directores (Opcional)', [])
       @reparto      = @OptionCtrl.newManyModel('Reparto (Opcional)', [])

       @panelesDeOpciones = [@temporada, @format, @calidad, @genero, @directores, @reparto, @idioma]
       
       @refreshForm()

       @cloneInput = ""
       
    refresh: () ->
       @item.capitulo = @capitulo.getSelected()
       @item.temporada = @temporada.getSelected()
       @item.format = @format.getSelected()
       @item.calidad = @calidad.getSelected()
       @item.genero = @genero.getSelected()
       @item.directores = @directores.getSelected()
       @item.reparto = @reparto.getSelected()
       @item.idioma = @idioma.getSelected()

    save: () ->
       @refresh()
       @SerieService.save(@item)

    refreshForm: () ->
       @capitulo.setSelected(@item.capitulo)
       @temporada.setSelected(@item.temporada)
       @format.setSelected(@item.format)
       @calidad.setSelected(@item.calidad)
       @genero.setSelected(@item.genero)
       @directores.setSelected(@item.directores)
       @reparto.setSelected(@item.reparto)
       @idioma.setSelected(@item.idioma)

    get: () ->
       @SerieService.getFromLPW(@cloneInput).then(() =>
            @item = @SerieService.selectedItem
            @item.postID = ""
            @item.posteador = "sawadypap"
            @refreshForm()
       )

controllersModule.controller('SaveSerieCtrl', SaveSerieCtrl)