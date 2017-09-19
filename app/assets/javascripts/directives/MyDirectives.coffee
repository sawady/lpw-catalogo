directivesModule.directive('navigationHeader', () ->
      restrict: 'E'
      templateUrl: '/assets/partials/views/navigationHeader.html'
   )

directivesModule.directive('optionManyForm', () -> 
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/forms/optionManyForm.html'
   )
   
directivesModule.directive('optionSingleForm', () -> 
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/forms/optionSingleForm.html'
   )
   
directivesModule.directive('optionManySearch', () -> 
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/searchForms/optionManySearch.html'
   )
   
directivesModule.directive('optionSingleSearch', () -> 
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/searchForms/optionSingleSearch.html'
   )
   
directivesModule.directive('textInputSearch', () -> 
      restrict: 'E'
      scope: {
        title: '='
        model: '='
      }
      templateUrl: '/assets/partials/searchForms/textInputSearch.html'
   )
   
directivesModule.directive('numberInputSearch', () -> 
      restrict: 'E'
      scope: {
        title: '='
        model: '='
      }
      templateUrl: '/assets/partials/searchForms/numberInputSearch.html'
   )
   
directivesModule.directive('postIdSearch', () -> 
      restrict: 'E'
      scope: {
        post: '='
      }
      templateUrl: '/assets/partials/searchForms/postIdSearch.html'
   )
   
directivesModule.directive('itemButtons', () -> 
      restrict: 'E'
      scope: {
        item:  '='
        model: '='
      }
      templateUrl: '/assets/partials/buttons/itemButtons.html'
   )
   
directivesModule.directive('searchPanel', () ->
      restrict: 'E'
      transclude: true
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/searchForms/searchPanel.html'
   )
   
directivesModule.directive('addItemButton', () ->
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/buttons/addItemButton.html'
   )

directivesModule.directive('paginationBar', () -> 
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/pagination/paginationBar.html'
   )
   
directivesModule.directive('paginationView', () ->
      restrict: 'E'
      transclude: true
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/views/paginationView.html'
   )
   
directivesModule.directive('simpleField', () ->
      restrict: 'E'
      scope: {
        title: '='
        model: '='
      }
      templateUrl: '/assets/partials/views/simpleField.html'
   )

directivesModule.directive('marco', () ->
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/views/marco.html'
   )
   
directivesModule.directive('idiomaField', () ->
      restrict: 'E'
      scope: {
        title: '='
        model: '='
      }
      templateUrl: '/assets/partials/views/idiomaField.html'
   )
   
directivesModule.directive('idiomaFlags', () ->
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/views/idiomaFlags.html'
   )
   
directivesModule.directive('manyField', () ->
      restrict: 'E'
      scope: {
        title: '='
        model: '='
      }
      templateUrl: '/assets/partials/views/manyField.html'
   )
   
directivesModule.directive('posteadorField', () ->
      restrict: 'E'
      scope: {
        model: '='
      }
      templateUrl: '/assets/partials/views/posteadorField.html'
   )
   
directivesModule.directive('sinopsisField', () ->
      restrict: 'E'
      scope: {
        title: '=',
        model: '='
      }
      templateUrl: '/assets/partials/views/sinopsisField.html'
   )