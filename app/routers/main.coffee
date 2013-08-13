AppView = require 'views/appView'

module.exports = class AppRouter extends Backbone.Router
    routes:
        "bretvictor":"bretvictor"
        "*path":"page1"
    
    page1: ->
        Hipster.Views.AppView = new AppView
    bretvictor: ->
        Hipster.Views.AppView = new AppView
            bretVictor: true