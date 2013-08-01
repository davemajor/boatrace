BearingsCollection = require 'collections/bearings'

describe 'BearingsCollection', ->
    beforeEach ->
        @collection = new BearingsCollection()

    it 'should exist', ->
        expect(@collection).to.be.ok
