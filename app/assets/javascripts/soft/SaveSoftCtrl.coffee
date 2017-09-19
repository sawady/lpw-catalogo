
class SaveSoftCtrl

    constructor: (@$log, @OptionCtrl, @SoftService) ->
       @$log.debug "constructing SaveSoftController"
       
       @item = @SoftService.selectedItem
       @SoftService.view()
       
       @tipo         = @OptionCtrl.newSingleModel('Tipo', @SoftService.tipoDefault)
       @platform     = @OptionCtrl.newSingleModel('Plataforma', @SoftService.platformDefault)
       @format       = @OptionCtrl.newSingleModel('Formato (Opcional)', @SoftService.formatDefault)
       @idioma       = @OptionCtrl.newManyModel('Idioma (Opcional)', @SoftService.idiomaDefaut)
       @requirements = @OptionCtrl.newSingleModel('Requisitos (Opcional)', @SoftService.requirementsDefault)
	
       @panelesDeOpciones = [@tipo, @platform, @format, @idioma, @requirements]
       
       @tipo.setSelected(@item.tipo)
       @platform.setSelected(@item.platform)
       @format.setSelected(@item.format)
       @idioma.setSelected(@item.idioma)
       @requirements.setSelected(@item.requirements)
       
    refresh: () ->
       @item.tipo = @tipo.getSelected()
       @item.platform = @platform.getSelected()
       @item.format = @format.getSelected()
       @item.idioma = @idioma.getSelected()
       @item.requirements = @requirements.getSelected()

    save: () ->
       @refresh()
       @SoftService.save(@item)

controllersModule.controller('SaveSoftCtrl', SaveSoftCtrl)