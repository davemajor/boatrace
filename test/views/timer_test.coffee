TimerView = require 'views/timer'

describe 'TimerView', ->
    beforeEach ->
        @view = new TimerView()

    it 'should exist', ->
        expect(@view).to.be.ok
