class OptionManyModel

    constructor: (@title, @opciones) ->
        @other = ""
        @selected = {}

        for clasico in @opciones
            @selected[clasico] = false
            
    reset: () ->
        @other = ""
        @selected = {}
        for clasico in @opciones
            @selected[clasico] = false
        
    addOther: () ->
        others = @other.split(', ')
        for oth in others
            if not (@other in @opciones) and @other
                @selected[oth] = true 
                @opciones.push(oth)
        @other = ""
        
    setSelected: (opts) ->
        if opts
            for o in opts
                @opciones.push(o) if not (o in @opciones)
                @selected[o] = true
                
    getSelected: () ->
        trulySelected = []
        for k in Object.keys(@selected)
            trulySelected.push(k) if @selected[k]
        return trulySelected
        
class OptionSingleModel

    constructor: (@title, @opciones) ->
        @other = ""
        @selected = ""

    reset: () ->
        @other = ""
        @selected = ""

    addOther: () ->
        if not (@other in @opciones) and @other
            @opciones.push(@other)
            @selected = @other
            @other = ""
        
    setSelected: (opt) ->
        if opt
            @opciones.push(opt) if not (opt in @opciones)
            @selected = opt
                
    getSelected: () ->
        return @selected

class OptionCtrl

    constructor: (@$log) ->
        @$log.debug "constructing OptionCtrl"
        
    newManyModel: (title, clasicos) ->
        return new OptionManyModel(title, clasicos)
        
    newSingleModel: (title, clasicos) ->
        return new OptionSingleModel(title, clasicos)

servicesModule.service('OptionCtrl', OptionCtrl)