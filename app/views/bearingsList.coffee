BearingsListItemView = require 'views/bearingsListItem'
BearingsCollection = require 'collections/bearings'
BearingModel = require 'models/bearing'
TimerView = require 'views/timer'

module.exports = class BearingsListView extends Backbone.View
    className: 'bearingsList'

    template: require 'views/templates/bearingsList'
    el: '.bearingsList'

    initialize: ->
        Hipster.Collections.Bearings = new BearingsCollection
        Hipster.Collections.Bearings.on('add', @addNewItem)
        Hipster.Collections.Bearings.on('add remove', @limitBearings)
        @render()

    render: ->
        $(@el).html @template
        Hipster.Views.TimerView = new TimerView
        @triggerAdd()

    limitBearings: ->
        num = Hipster.Collections.Bearings.models.length
        if num == 8
            $('.add-new').css('opacity',0.5)
        else
            $('.add-new').css('opacity',1)

    addNewItem: (bearing) ->
        view = new BearingsListItemView
            model: bearing
        $('.bearingsList ul').append view.render().el

    triggerAdd: ->
        if Hipster.Collections.Bearings.models.length < 8
            Hipster.Collections.Bearings.add new BearingModel

    triggerRace: ->
        Hipster.Views.MapView.trigger 'race'

    close: ->
        $(@el).empty()
        $(@el).unbind()

    events: ->
        'click .action-add-item': 'triggerAdd'
        'click .action-race': 'triggerRace'

