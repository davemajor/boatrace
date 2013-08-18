BearingsListView = require 'views/bearingsList'
ResultsView = require 'views/resultsView'
MapView = require 'views/map'
RoutesCollection = require 'collections/routes'
BearingsCollection = require 'collections/bearings'
RouteModel = require 'models/route'

module.exports = class AppViewView extends Backbone.View
    className: 'appView'
    el: '.app'
    page2: false

    initialize: ->
        page = Hipster.Routers.Main.page
        Hipster.Collections.Bearings = new BearingsCollection
        Hipster.Models.Route = new RouteModel

        if page == 'page2'
            @renderPage2()
        else
            Hipster.Collections.Routes = new RoutesCollection
            Hipster.Collections.Routes.on 'sync', @render, this
            Hipster.Collections.Routes.fetch()

    render: ->
        Hipster.Views.BearingsListView = new BearingsListView
        Hipster.Views.MapView = new MapView

    renderPage2: ->
        Hipster.Collections.Routes = new RoutesCollection
        
        Hipster.Views.MapView = new MapView
        Hipster.Views.BearingsListView = new BearingsListView