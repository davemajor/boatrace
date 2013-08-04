BearingsListView = require 'views/bearingsList'
RouteModel = require 'models/route'

module.exports = class ResultsViewView extends Backbone.View
    className: 'resultsView'

    template: require 'views/templates/resultsView'
    el: '.bearingsList'

    initialize: ->
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
        @render()

    render: ->
        $(@el).html @template
            ranking: @ranking

    close: ->
        $(@el).empty()
        $(@el).unbind()
        Hipster.Models.Route = new RouteModel
        Hipster.Views.BearingsListView = new BearingsListView

    events:
        "click button": 'close'

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