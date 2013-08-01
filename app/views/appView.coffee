BearingsListView = require 'views/bearingsList'
MapView = require 'views/map'

module.exports = class AppViewView extends Backbone.View
    className: 'appView'
    el: '.app'

    initialize: ->
        Hipster.Views.BearingsListView = new BearingsListView
        Hipster.Views.MapView = new MapView
        
        @render()

    render: ->

