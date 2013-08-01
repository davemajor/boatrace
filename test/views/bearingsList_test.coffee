BearingsListView = require 'views/bearingsList'

describe 'BearingsListView', ->
    beforeEach ->
        @view = new BearingsListView()

    it 'should exist', ->
        expect(@view).to.be.ok
