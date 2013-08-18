BearingsListView = require 'views/bearingsList'
RouteModel = require 'models/route'

module.exports = class ResultsViewView extends Backbone.View
    className: 'resultsView'

    template: require 'views/templates/resultsView'
    page2Template: require 'views/templates/page2ResultsView'
    el: '.bearingsList'

    initialize: (options) ->
        if options? and options.distance?
            @distance = options.distance
            @renderPage2()
        else
            @calcRanking()
            @render()

    calcRanking: ->
        result = Hipster.Models.Route.get 'time'

        times = Hipster.Collections.Routes.pluck "time"
        times = times.sort(
            (a, b) ->
                return a-b
        )

        times = times.getUnique()
        nearest = _.find times, (time) =>
            time >= parseFloat(result)

        @ranking = times.indexOf nearest
        if @ranking == -1
            @ranking++
        @ranking++

    render: ->
        $(@el).html @template
            ranking: @ranking

    renderPage2: ->
        $(@el).html @page2Template
            distance: @distance

    close: ->
        $(@el).empty()
        $(@el).unbind()
        Hipster.Models.Route = new RouteModel
        if Hipster.Routers.Main.page == 'page2'
            Hipster.Views.MapView.trigger 'reset'
        Hipster.Views.BearingsListView = new BearingsListView

    page2: ->
        Hipster.Views.MapView.close()
        @close()
        Backbone.history.navigate('boatrace/page2',{trigger:true})

    events:
        'click button[name="action-try-again"]': 'close'
        'click button[name="action-move-on"]': 'page2'

    Array::getUnique = ->
        u = {}
        a = []
        i = 0
        l = @length

        while i < l
            if a.indexOf(this[i]) == -1
                a.push this[i]
            ++i
        a