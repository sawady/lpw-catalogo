
class UserCtrl

    constructor: (@$log, @$location, @$modal, @UsersService) ->
        @$log.debug "constructing UserController"
        @user = @UsersService.user
    
    logOut: () ->
      @UsersService.logOut()
      @user = @UsersService.user
      
    isInvitado: () ->
      return @UsersService.isInvitado()
      
    puedeAgregarUsuario: () ->
      return @UsersService.isAdmin()
      
    puedeBorrarUsuario: () ->
      return @UsersService.isAdmin()
    
    # LOGUEO
    openLogIn: () ->
    
      modalCtrl = ($scope, $log, $modalInstance, UsersService) ->
          $scope.user = 
               user: ""
               pass: "" 
          
          $scope.userData = 
               user: ""
               pass: ""
            
          $scope.msg = ""
      
          $scope.ok = () ->
              UsersService.validateUser($scope.user)
              .then(
                   (data) =>
                      if data.error?
                          $scope.msg = "Usuario inválido"
                      else
                          $scope.msg = "Log in correcto"
                          $scope.userData = data
                          UsersService.setUser($scope.user.user, $scope.userData.role, $scope.userData.catalogs)
                          $modalInstance.close(true)
                   ,
                   (error) =>
                      $log.error "Unable to get User: #{error}"
                      $scope.msg = "Usuario invalido"
                   )

          $scope.cancel = () ->
              $modalInstance.dismiss(false)
    
      modalInstance = @$modal.open(
          templateUrl: '/assets/partials/modals/onLogInModal.html'
          controller: modalCtrl
      )
                    
      loggg  = @$log
      m = this
      
      onOk = (answer) -> 
                 loggg.info('Accepted log in') if answer
        
      onOther = () -> loggg.info('Modal dismissed at: ' + new Date())
       
      modalInstance.result.then(onOk, onOther)
    
    # AGREGAR USUARIO  
    openAddUser: () ->
    
      modalCtrl = ($scope, $log, $modalInstance, UsersService) ->
          $scope.user =
               user: ""
               pass: ""
               role: ""
               catalogs:
                      movies: false
                      games: false
                      music: false
                      series: false
                      soft: false
                       
          $scope.msg = ""
          
          $scope.allFalse = (catalogs) ->
              for key, value of catalogs
                  if value
                      return false
              return true
              
          $scope.putCatalogs = (user) ->
              resCat = []
              for key, value of user.catalogs
                  if value
                      resCat.push(key)
              user.catalogs = resCat
      
          $scope.ok = () ->
              if $scope.user.role.length == 0
                 $scope.msg = "Ingrese un rol"
              else if $scope.user.pass.length == 0
                 $scope.msg = "Ingrese una contraseña válida"
              else if $scope.user.user.length == 0
                 $scope.msg = "Ingrese un nombre de usuario válido"
              else if $scope.user.role isnt "admin" and $scope.allFalse($scope.user.catalogs)
                 $scope.msg = "Si no es admin por favor ingrese al menos un catalogo para el usuario"
              else if $scope.user.user.length > 0 and $scope.user.pass.length > 0 and $scope.user.role.length > 0
                 $scope.putCatalogs($scope.user)
                 UsersService.saveUser($scope.user).then( (data) =>
	                     $scope.msg = "El usuario ha sido creado"
	                     $modalInstance.close(true)
	                , (error) =>
	                     $log.error "Unable to get User: #{error}"
	                     $scope.msg = "Error: imposible crear usuario"
                 )

          $scope.cancel = () ->
              $modalInstance.dismiss(false)
    
      modalInstance = @$modal.open(
          templateUrl: '/assets/partials/modals/onAddUserModal.html'
          controller: modalCtrl
      )
                    
      loggg  = @$log
      m = this
      
      onOk = (answer) -> 
                 loggg.info('Accepted add user') if answer
        
      onOther = () -> loggg.info('Modal dismissed at: ' + new Date())
       
      modalInstance.result.then(onOk, onOther)

    # AGREGAR USUARIO  
    openDeleteUser: () ->
    
      modalCtrl = ($scope, $log, $modalInstance, UsersService) ->
          $scope.user =
               user: ""
                       
          $scope.msg = ""
      
          $scope.ok = () ->
              if $scope.user.user.length == 0
                 $scope.msg = "Ingrese un nombre de usuario válido"
              else
                 UsersService.deleteUser($scope.user).then( (data) =>
	                     $scope.msg = "El usuario ha sido borrado"
	                     $modalInstance.close(true)
	                , (error) =>
	                     $log.error "Unable to delete User: #{error}"
	                     $scope.msg = "Error: imposible borrar usuario"
                 )

          $scope.cancel = () ->
              $modalInstance.dismiss(false)
    
      modalInstance = @$modal.open(
          templateUrl: '/assets/partials/modals/onDeleteUserModal.html'
          controller: modalCtrl
      )
                    
      loggg  = @$log
      m = this
      
      onOk = (answer) -> 
                 loggg.info('Accepted deletion of user') if answer
        
      onOther = () -> loggg.info('Modal dismissed at: ' + new Date())
       
      modalInstance.result.then(onOk, onOther)
      
    # CAMBIAR CONTRASEÑA  
    openChangePass: () ->
    
      modalCtrl = ($scope, $log, $modalInstance, UsersService) ->
          $scope.user =
               user: UsersService.user.user
               pass: ""
               newPass: ""
            
          $scope.msg = ""
      
          $scope.ok = () ->
              if $scope.user.newPass.length == 0
                 $scope.msg = "Ingrese una nueva contraseña"
              if $scope.user.pass.length == 0
                 $scope.msg = "Ingrese la vieja contraseña"
              if $scope.user.user.length == 0
                 $scope.msg = "Ingrese un nombre de usuario válido"
                 
              if $scope.user.user.length > 0 and $scope.user.pass.length > 0 and $scope.user.newPass.length > 0
	              UsersService.changePass($scope.user)
	              .then(
	                   (data) =>
	                      $scope.msg = "La contraseña ha cambiado exitosamente"
	                      $modalInstance.close(true)
	                   ,
	                   (error) =>
	                      $log.error "Unable to get User: #{error}"
	                      $scope.msg = "Error: imposible cambiar contraseña"
	                   )

          $scope.cancel = () ->
              $modalInstance.dismiss(false)
    
      modalInstance = @$modal.open(
          templateUrl: '/assets/partials/modals/onChangePassModal.html'
          controller: modalCtrl
      )
                    
      loggg  = @$log
      m = this
      
      onOk = (answer) -> 
                 loggg.info('Accepted change pass') if answer
        
      onOther = () -> loggg.info('Modal dismissed at: ' + new Date())
       
      modalInstance.result.then(onOk, onOther)
      

controllersModule.controller('UserCtrl', UserCtrl)