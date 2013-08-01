MapView = require 'views/map'

describe 'MapView', ->
    beforeEach ->
        @view = new MapView()

    it 'should exist', ->
        expect(@view).to.be.ok
