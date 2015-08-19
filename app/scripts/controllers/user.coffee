###*
 # @ngdoc function
 # @name bbsApp.controller:UserCtrl
 # @description
 # # UserCtrl
 # Controller of the bbsApp
###
angular.module('bbsApp')
  .controller 'UserCtrl', ($scope) ->
    $scope.users = [
      'a'
      'b'
      'c'
    ]
