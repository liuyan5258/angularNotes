'use strict'

###*
 # @ngdoc function
 # @name bbsApp.controller:SingleCtrl
 # @description
 # # SingleCtrl
 # Controller of the bbsApp
###
angular.module('bbsApp')
  .controller 'SingleCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
