'use strict'

describe 'Service: values', ->

  # load the service's module
  beforeEach module 'bbsApp'

  # instantiate service
  values = {}
  beforeEach inject (_values_) ->
    values = _values_

  it 'should do something', ->
    expect(!!values).toBe true
