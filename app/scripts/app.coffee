###
@ngdoc overview
@name bbsApp
@description
# bbsApp

Main module of the application.
###
angular.module("bbsApp", [
  "ngRoute"
  "ngTouch"
  "utils"
])
.run ($rootScope, $routeParams)->
  $rootScope.$on '$routeChangeError', (current, previous, rejection)->
    console.log rejection
    return
  return
.config ($routeProvider)->
  $routeProvider
    .when '/',
      controller: 'MainCtrl'
      templateUrl: 'views/main.html'

    .when '/user',
      controller: 'UserCtrl'
      templateUrl: 'views/user.html'
    .otherwise {redirectTo: '/'}