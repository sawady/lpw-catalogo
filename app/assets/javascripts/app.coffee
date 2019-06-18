
dependencies = [
    'ngRoute',
    'ngAnimate',
    'ngCookies',
    'ui.bootstrap',
    'angular-loading-bar',
    'ui.utils',
    'myApp.filters',
    'myApp.services',
    'myApp.controllers',
    'myApp.directives',
    'myApp.common',
    'myApp.routeConfig'
]

app = angular.module('myApp', dependencies)

angular.module('myApp.routeConfig', ['ngRoute'])
    .config ($routeProvider) ->
        $routeProvider
            .when('/users/', {
                templateUrl: '/assets/partials/users.html'
            })
            .when('/movies/form', {
                templateUrl: '/assets/partials/forms/formMovies.html'
            })
            .when('/games/form', {
                templateUrl: '/assets/partials/forms/formGames.html'
            })
            .when('/music/form', {
                templateUrl: '/assets/partials/forms/formMusic.html'
            })
            .when('/series/form', {
                templateUrl: '/assets/partials/forms/formSeries.html'
            })
            .when('/soft/form', {
                templateUrl: '/assets/partials/forms/formSoft.html'
            })
            .when('/movies/:posteador?', {
                templateUrl: '/assets/partials/viewMovies.html'
            })
            .when('/games/:posteador?', {
                templateUrl: '/assets/partials/viewGames.html'
            })
            .when('/music/:posteador?', {
                templateUrl: '/assets/partials/viewMusic.html'
            })
            .when('/series/:posteador?', {
                templateUrl: '/assets/partials/viewSeries.html'
            })
            .when('/soft/:posteador?', {
                templateUrl: '/assets/partials/viewSoft.html'
            })
            .otherwise({redirectTo: '/movies/'})

app.directive('back', ['$window', ($window) ->
	    restrict: 'A',
	    link: (scope, elem, attrs) -> 
	        elem.bind('click', () ->
	           $window.history.back()
	        )
   ])

app.config( ($logProvider) ->
  $logProvider.debugEnabled(false)
)
   
@commonModule = angular.module('myApp.common', [])
@controllersModule = angular.module('myApp.controllers', [])
@servicesModule = angular.module('myApp.services', [])
@modelsModule = angular.module('myApp.models', [])
@directivesModule = angular.module('myApp.directives', [])
@filtersModule = angular.module('myApp.filters', [])