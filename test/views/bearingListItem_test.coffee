BearingListItemView = require 'views/bearingListItem'

describe 'BearingListItemView', ->
    beforeEach ->
        @view = new BearingListItemView()

    it 'should exist', ->
        expect(@view).to.be.ok
