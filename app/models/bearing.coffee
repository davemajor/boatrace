module.exports = class BearingModel extends Backbone.Model
    defaults:
        directionX: 'east'
        directionY: 'north'

    isValid: ->
        @get('distance') > 0 && @get('degrees') >0