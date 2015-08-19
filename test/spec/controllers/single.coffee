'use strict'

describe 'Controller: SingleCtrl', ->

  # load the controller's module
  beforeEach module 'bbsApp'

  SingleCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SingleCtrl = $controller 'SingleCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
