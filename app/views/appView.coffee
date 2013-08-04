BearingsListView = require 'views/bearingsList'
ResultsView = require 'views/resultsView'
MapView = require 'views/map'
RoutesCollection = require 'collections/routes'
RouteModel = require 'models/route'

module.exports = class AppViewView extends Backbone.View
    className: 'appView'
    el: '.app'

    initialize: ->
        Hipster.Views.BearingsListView = new BearingsListView
        # Hipster.Views.BearingsListView = new ResultsView
        Hipster.Views.MapView = new MapView

        Hipster.Collections.Routes = new RoutesCollection
        Hipster.Models.Route = new RouteModel

        Hipster.Collections.Routes.fetch()

        @render()

    render: ->

