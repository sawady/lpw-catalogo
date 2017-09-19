
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
            .when('/movies/', {
                templateUrl: '/assets/partials/viewMovies.html'
            })
            .when('/movies/form', {
                templateUrl: '/assets/partials/forms/formMovies.html'
            })
            .when('/games/', {
                templateUrl: '/assets/partials/viewGames.html'
            })
            .when('/games/form', {
                templateUrl: '/assets/partials/forms/formGames.html'
            })
            .when('/music/', {
                templateUrl: '/assets/partials/viewMusic.html'
            })
            .when('/music/form', {
                templateUrl: '/assets/partials/forms/formMusic.html'
            })
            .when('/series/', {
                templateUrl: '/assets/partials/viewSeries.html'
            })
            .when('/series/form', {
                templateUrl: '/assets/partials/forms/formSeries.html'
            })
            .when('/soft/', {
                templateUrl: '/assets/partials/viewSoft.html'
            })
            .when('/soft/form', {
                templateUrl: '/assets/partials/forms/formSoft.html'
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