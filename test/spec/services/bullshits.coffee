'use strict'

describe 'Service: bullshits', ->

  # load the service's module
  beforeEach module 'bbsApp'

  # instantiate service
  bullshits = {}
  beforeEach inject (_bullshits_) ->
    bullshits = _bullshits_

  it 'should do something', ->
    expect(!!bullshits).toBe true
