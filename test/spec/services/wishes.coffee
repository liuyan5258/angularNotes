'use strict'

describe 'Service: wishes', ->

  # load the service's module
  beforeEach module 'bbsApp'

  # instantiate service
  wishes = {}
  beforeEach inject (_wishes_) ->
    wishes = _wishes_

  it 'should do something', ->
    expect(!!wishes).toBe true
