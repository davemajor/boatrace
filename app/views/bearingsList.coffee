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
        @render()

    render: ->
        $(@el).html @template
        Hipster.Views.TimerView = new TimerView
        @triggerAdd()

    addNewItem: (bearing) ->
        view = new BearingsListItemView
            model: bearing
        $('.bearingsList ul').append view.render().el

    triggerAdd: ->
        Hipster.Collections.Bearings.add new BearingModel

    triggerRace: ->
        Hipster.Views.MapView.trigger 'race'

    close: ->
        $(@el).empty()
        $(@el).unbind()

    events: ->
        'click .action-add-item': 'triggerAdd'
        'click .action-race': 'triggerRace'

