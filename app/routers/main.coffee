AppView = require 'views/appView'

module.exports = class AppRouter extends Backbone.Router
    page: ''
    routes:
        "boatrace/bretvictor/":"bretvictor"
        "boatrace/page2":"page2"
        "*path":"page1"

    page1:(path) ->
        @page = "page1"
        Hipster.Views.AppView = new AppView
    bretvictor: ->
        @page = "bretVictor"
        Hipster.Views.AppView = new AppView
    page2: ->
        @page = "page2"
        Hipster.Views.AppView = new AppView