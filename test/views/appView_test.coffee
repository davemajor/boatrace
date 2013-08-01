AppViewView = require 'views/appView'

describe 'AppViewView', ->
    beforeEach ->
        @view = new AppViewView()

    it 'should exist', ->
        expect(@view).to.be.ok
