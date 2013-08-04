module.exports = class BearingModel extends Backbone.Model
    defaults:
        directionX: 'east'
        directionY: 'north'
    initialize: ->
        @on 'change', @isValid
    isValid: ->
        if @get('distance') > 0 && @get('degrees') >= 0 &&
        @get('degrees') <= 360
            @trigger 'valid'
            true
        else
            @trigger 'invalid'
            false