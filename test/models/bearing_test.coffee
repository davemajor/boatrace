BearingModel = require 'models/bearing'

describe 'BearingModel', ->
    beforeEach ->
        @model = new BearingModel()

    it 'should exist', ->
        expect(@model).to.be.ok
