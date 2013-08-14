AppView = require 'views/appView'

module.exports = class AppRouter extends Backbone.Router
    routes:
        "boatrace/bretvictor/":"bretvictor"
        "*path":"page1"

    page1:(path) ->
        Hipster.Views.AppView = new AppView
            bretVictor: false
    bretvictor: ->
        Hipster.Views.AppView = new AppView
            bretVictor: true