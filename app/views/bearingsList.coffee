BearingsListItemView = require 'views/bearingsListItem'
BearingModel = require 'models/bearing'
TimerView = require 'views/timer'

module.exports = class BearingsListView extends Backbone.View
    className: 'bearingsList'

    template: require 'views/templates/bearingsList'
    page2Template: require 'views/templates/page2BearingsList'
    el: '.bearingsList'

    initialize: ->
        @page = Hipster.Routers.Main.page

        if @page == 'page2'
            mapWidth = $('svg').width()
            mapHeight = $('svg').height()

            @readonly = true
            bearings = []
            x = 100
            y = 100
            while bearings.length < 3
                bearing = @randomBearing()
                bearingOK = false
                degrees = bearing.degrees
                if bearing.directionY == 'north'
                    if bearing.directionX == 'east'
                        degrees += 0
                    else
                        degrees += 90
                else
                    if bearing.directionX == 'east'
                        degrees += 180
                    else
                        degrees += -180

                dx = Math.cos(
                    degrees/180 * Math.PI) * bearing.distance*10
                dy = Math.sin(
                    degrees/180 * Math.PI) * bearing.distance*10

                bearingOK = x+dx > 100 and y+(dy*-1) > 100 and
                x+dx < mapWidth and y+(dy*-1)< mapHeight

                if bearingOK
                    x += dx
                    y += dy*-1
                    bearings.push bearing

            Hipster.Collections.Bearings.reset bearings
            @renderPage2()
        else
            $('button').removeAttr 'disabled'
            @readonly = false
            Hipster.Collections.Bearings.on('add', @addNewItem)
            Hipster.Collections.Bearings.on('add remove', @limitBearings)
            @render()

    randomBearing : ->
        {
            distance: Math.floor(Math.random() * (50 - 10 + 1)) + 10
            degrees: Math.floor(Math.random() * (90 - 1 + 1)) + 1
            directionX: _.shuffle(['east', 'west'])[0]
            directionY: _.shuffle(['north', 'south'])[0]
        }

    renderPage2: ->
        $(@el).html @page2Template
        if Hipster.Collections.Bearings.models.length > 0
            _.each Hipster.Collections.Bearings.models, (model) =>
                @addNewItem model
        else
            @triggerAdd()

    render: ->
        topString = ""
        times = Hipster.Collections.Routes.pluck 'time'
        times = times.sort(
            (a, b) ->
                return a-b
        )
        times = times.getUnique()
        top = _.first times, 5

        topString = top.join ', '
        topString = topString.replace(/,([^,]*)$/,' &'+'$1')
        $(@el).html @template
            top: topString + ' minutes'
            bretVictor: @page == 'bretVictor'
        Hipster.Views.TimerView = new TimerView
        if Hipster.Collections.Bearings.models.length > 0
            _.each Hipster.Collections.Bearings.models, (model) =>
                @addNewItem model
        else
            @triggerAdd()

    limitBearings: ->
        num = Hipster.Collections.Bearings.models.length
        if num == 8
            $('.add-new').css('opacity',0.5)
        else
            $('.add-new').css('opacity',1)

    addNewItem: (bearing) ->
        view = new BearingsListItemView
            model: bearing
            readonly: @readonly
        $('.bearingsList ul').append view.render().el

    triggerAdd: ->
        if Hipster.Collections.Bearings.models.length < 8
            Hipster.Collections.Bearings.add new BearingModel

    triggerRace: ->
        Hipster.Views.MapView.trigger 'race'

    close: ->
        $(@el).empty()
        $(@el).unbind()

    events: ->
        'click .action-add-item': 'triggerAdd'
        'click .action-race': 'triggerRace'


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