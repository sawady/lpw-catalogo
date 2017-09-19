
class SaveGameCtrl

    constructor: (@$log, @OptionCtrl, @GameService) ->
       @$log.debug "constructing SaveGameController"
       
       @item = @GameService.selectedItem
       @GameService.view()
       
       @format       = @OptionCtrl.newSingleModel('Formato (Opcional)', @GameService.formatDefault)
       @platform     = @OptionCtrl.newSingleModel('Plataforma', @GameService.platformDefault)
       @audio        = @OptionCtrl.newManyModel('Audio (Opcional)', @GameService.audioDefault)
       @text         = @OptionCtrl.newManyModel('Texto (Opcional)', @GameService.textDefault)
       @genero       = @OptionCtrl.newManyModel('Genero (Opcional)', @GameService.generoDefault)
       @requirements = @OptionCtrl.newSingleModel('Requisitos (Opcional)', @GameService.requirementsDefault)
       
       @panelesDeOpciones = [@format, @platform, @audio, @text, @genero, @requirements]
       
       @format.setSelected(@item.format)
       @platform.setSelected(@item.platform)
       @audio.setSelected(@item.audio)
       @text.setSelected(@item.text)
       @genero.setSelected(@item.genero)
       @requirements.setSelected(@item.requirements)        
       
    refresh: () ->
       @item.format = @format.getSelected()
       @item.platform = @platform.getSelected()
       @item.audio = @audio.getSelected()
       @item.text = @text.getSelected()
       @item.genero = @genero.getSelected()
       @item.requirements = @requirements.getSelected()

    save: () ->
       @refresh()
       @GameService.save(@item)

controllersModule.controller('SaveGameCtrl', SaveGameCtrl)