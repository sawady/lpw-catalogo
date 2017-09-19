
class UsersService

    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @defaultConfig = { headers: @headers }

    constructor: (@$log, @$location, @$http, @$cookieStore, @$q) ->
        @$log.debug "constructing UsersService"
        usC = @$cookieStore.get('user')
        if usC
            @user = usC
        else
            @setInvitado()
            
    getRoles: () ->
        return ["admin","mod","uploader"]

    getCatalogs: () ->
        return ["movies", "games", "music", "series", "soft"]
    
    isAdmin: () ->
        @user.role == "admin"
    
    isMod: (catalog) ->
        if @user.role == "mod"
           catalog in @user.catalogs
        else
           @isAdmin()
        
    isUploader: (catalog, item) ->
        if @user.role == "uploader"
           if item
               catalog in @user.catalogs and @user.user == item.posteador
           else
               catalog in @user.catalogs
        else
           @isMod(catalog)
            
    isInvitado: () ->
        @user.role == "invitado"
            
    setInvitado: () ->
        @user = { user: "Invitado", role: "invitado" }
        
    setUser: (aUser, aRole, aCatalogs) ->
        @user.user = aUser
        @user.role = aRole
        if aCatalogs
            @user.catalogs = aCatalogs
        @$cookieStore.put('user', @user)
        
    logOut: () ->
        @$cookieStore.remove('user')
        @setInvitado()
        @$location.path("/movies")

    hashPass: (user) ->
        userToSend = angular.copy(user)
        userToSend.pass = CryptoJS.MD5(userToSend.pass).toString(CryptoJS.enc.Base64)
        return userToSend

    hashNewPass: (user) ->
        userToSend = angular.copy(user)
        userToSend.newPass = CryptoJS.MD5(userToSend.newPass).toString(CryptoJS.enc.Base64)
        return userToSend

    validateUser: (anUser) ->
        anUser = @hashPass(anUser)
        
        @$log.debug "validate #{angular.toJson(anUser.user)}"
        deferred = @$q.defer()
        
        @$http.post("/users", anUser)
        .success((data, status, headers) =>
                @$log.info("Successfully validated user - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to validate user - status #{status}")
                deferred.reject(data)
            )
        deferred.promise

    changePass: (anUser) ->
        anUser = @hashPass(anUser)
        anUser = @hashNewPass(anUser)
        @$log.debug "saveUser #{angular.toJson(anUser)}"
        deferred = @$q.defer()

        @$http.post('/users/changePass', anUser)
        .success((data, status, headers) =>
                @$log.info("Successfully created user - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create user - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

    saveUser: (anUser) ->
        anUser = @hashPass(anUser)
        @$log.debug "saveUser #{angular.toJson(anUser)}"
        deferred = @$q.defer()

        @$http.post('/users/save', anUser)
        .success((data, status, headers) =>
                @$log.info("Successfully created user - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to create user - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

    deleteUser: (anUser) ->
        @$log.debug "deleteUser #{angular.toJson(anUser)}"
        deferred = @$q.defer()

        @$http.post('/users/delete', anUser)
        .success((data, status, headers) =>
                @$log.info("Successfully deleted user - status #{status}")
                deferred.resolve(data)
            )
        .error((data, status, headers) =>
                @$log.error("Failed to delete user - status #{status}")
                deferred.reject(data);
            )
        deferred.promise

servicesModule.service('UsersService', UsersService)