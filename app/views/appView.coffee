BearingsListView = require 'views/bearingsList'
ResultsView = require 'views/resultsView'
MapView = require 'views/map'
RoutesCollection = require 'collections/routes'
BearingsCollection = require 'collections/bearings'
RouteModel = require 'models/route'

module.exports = class AppViewView extends Backbone.View
    className: 'appView'
    el: '.app'

    initialize: (options) ->
        @bretVictor = if options? && options.bretVictor?
        then options.bretVictor else false

        Hipster.Collections.Bearings = new BearingsCollection
        Hipster.Collections.Routes = new RoutesCollection
        Hipster.Collections.Routes.on 'sync', @render
        Hipster.Models.Route = new RouteModel

        Hipster.Collections.Routes.fetch()


    render: ->
        Hipster.Views.BearingsListView = new BearingsListView
            bretVictor: @bretVictor
        Hipster.Views.MapView = new MapView
            bretVictor: @bretVictor

