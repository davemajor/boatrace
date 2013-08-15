ResultsView = require 'views/resultsView'

module.exports = class MapView extends Backbone.View
    className: 'map'
    el: '.map'
    template: require 'views/templates/map'

    initialize: (options) ->
        @bretVictor = options.bretVictor
        @speed = 20

        if @bretVictor
            Hipster.Collections.Bearings.on 'redraw', =>
                $('path').remove()
                $('text').remove()
                @paper.path('M25 35 L125 35').attr(
                    'stroke':'white'
                    'stroke-width':'2'
                    'opacity': '0.4'
                )
                @paper.text(75, 25, "10 miles").attr(
                    'font-family':'Helvetica'
                    'fill':'white'
                )
                @x = 100
                @y = 100
                @drawStep()
            , this
        else
            @on 'race', @race, this
            @on 'step', @drawStep, this
            @on 'tick', @tick, this

        @render()

    reset: ->
        $('.error').hide()
        clearTimeout(@timer)
        @paper.clear()
        @paper.path('M25 35 L125 35').attr(
            'stroke':'white'
            'stroke-width':'2'
            'opacity': '0.4'
        )
        @paper.text(75, 25, "10 miles").attr(
            'font-family':'Helvetica'
            'fill':'white'
        )
        @steps = []
        @x = 100
        @y = 100
        @time = 0
        @elapsed = 0
        @step = 0
        @timer = 0
        @playing = false
        @distanceTravelled = 0
        @startTime = 0
        @boat = @paper.image("images/boat.png", @x-11, @y-12, 22, 24)
        @endZone = @paper.circle(
            @boat.attr('x') + 11
            @boat.attr('y') + 12
            40
        ).attr(
            "fill": "white"
            "opacity": 0.2
            "stroke": "none"
        )
        @drawBouys([
            {x: 140, y: 150},
            {x: 260, y: 500},
            {x: 450, y: 580},
            {x: 560, y: 300},
            {x: 360, y: 100}]
        )

    drawBouys: (buoys) ->
        _.each buoys, (buoy) =>
            @paper.image("images/buoy.png", buoy.x-12, buoy.y-12, 25, 25)
        @boundary = @paper.path 'M{0} {1} L{2} {3} {4} {5} {6} {7} {8} {9}z',
        buoys[0].x, buoys[0].y, buoys[1].x, buoys[1].y,
        buoys[2].x, buoys[2].y, buoys[3].x, buoys[3].y,
        buoys[4].x, buoys[4].y
        @boundary.attr
            'stroke': 'none'

    tick: ->
        if @playing
            @time += 100
            @elapsed = Math.floor(@time / 1000) / 10
            @elapsed += ".0"  if Math.round(@elapsed) is @elapsed
            Hipster.Views.TimerView.trigger 'update', @elapsed
            diff = (new Date().getTime() - @startTime) - @time
            @timer = setTimeout(=> @trigger 'tick', (100 - diff))

    race: ->
        if !Hipster.Collections.Bearings.models[0].isValid()
            return
        @reset()
        if !@bretVictor
            @endZone = @paper.circle(
                @boat.attr('x') + 11
                @boat.attr('y') + 12
                0
            ).attr(
                "fill": "white"
                "opacity": 0.2
                "stroke": "none"
            ).animate(
                r: 40
            , 200
            ).toFront()
            @startTime = new Date().getTime()
            @playing = true
            @timer = setTimeout @tick(), 100
        @drawStep()

    drawStep: ->
        attrs = {"stroke-dasharray":'.', 'stroke-width':'3', 'stroke': '#fff'}
        if !@bretVictor
            if @step < Hipster.Collections.Bearings.length
                if Hipster.Collections.Bearings.models[@step].isValid()
                    $("path").css('opacity', 0.4)
                    @paper.image(
                        "images/boat.png"
                        @boat.attr("x")
                        @boat.attr("y")
                        22
                        24
                    ).attr
                        opacity: 0.4

                    @makeMovement Hipster.Collections.Bearings.at @step
                else
                    @playing = false
                    @check()
                @step++
            else
                @playing = false
                @check()
        else
            _.each Hipster.Collections.Bearings.models, (model) =>
                if model.isValid()
                    @makeMapStep model
            @boat.attr(
                x: @x - 11
                y: @y - 12
                opacity: 0.4
            )

    render: ->
        @paper = Raphael(@el, '100%', '100%')
        @reset()

    check: ->
        if _this.distanceTravelled < _this.boundary.getTotalLength()
            $('#timer > h3').hide()
            $('.too-short').show()
            return
        inEndPoint = @paper.getElementsByPoint(
            @boat.attr('x')
            @boat.attr('y')
        )
        success = _.find inEndPoint.items, (element) =>
            element.type == "circle"
        success = success != undefined

        if success
            Hipster.Models.Route.set
                time: @elapsed
                bearings: Hipster.Collections.Bearings
            Hipster.Models.Route.save()
            Hipster.Views.BearingsListView.close()
            Hipster.Views.ResultsView3 = new ResultsView
        else
            $('#timer > h3').hide()
            $('.missed').show()


    makeMovement: (model) =>
        dist = parseFloat model.get('distance') * 10
        deg = parseFloat model.get('degrees')

        ew = model.get('directionX')
        ns = model.get('directionY')

        @distanceTravelled += dist

        dist = -dist if ew == "west"
        mod = 1
        if ns == "south"
            label = @paper.text @x, @y + 20, 0
            if ew == "west"
                mod = -1
        else
            label = @paper.text @x, @y - 20, 0
            if ew == "east"
                mod = -1

        label.attr(
            'font-family':'Helvetica'
            'fill':'white'
        )

        ewLine = @paper.path("M" + @x + " " + @y + "L" + (@x + dist) + " " + @y)
        .attr
            "stroke-dasharray":'.'
            'stroke-width':'3'
            'stroke': '#fff'
        .toBack()
        ewLabelPos = ewLine.getPointAtLength(Math.abs dist)
        if ew == "east"
            ewLabel = @paper.text(ewLabelPos.x + 20, ewLabelPos.y, "E").attr(
                'font-family':'Helvetica'
                'fill':'white'
            )
        else
            ewLabel = @paper.text(ewLabelPos.x - 20, ewLabelPos.y, "W").attr(
                'font-family':'Helvetica'
                'fill':'white'
            )
        line = ewLine.clone().toBack()
        i = 0
        animateLine = =>
            moveBoat = =>
                rotatedLine = _this.paper.path(
                    Raphael.transformPath(
                        line.attr("path"), "r" + mod*deg + "," + @x + "," + @y
                    )
                ).attr(stroke: "none")
                target = rotatedLine.getPointAtLength(Math.abs dist)
                _this.boat.animate
                    x: target.x - 11
                    y: target.y - 12
                , 500, =>
                    _this.x = target.x
                    _this.y = target.y
                    ewLine.remove()
                    ewLabel.remove()
                    $("path").css 'opacity', 0.4

                    # Check for boundary intersection
                    s = Raphael.pathIntersection(
                        _this.boundary.attr('path').toString()
                        rotatedLine.attr('path').toString()
                    )
                    if s.length > 0
                        # Kill it
                        _this.playing = false
                        _this.paper.path(rotatedLine.attr('path')).attr({
                            'stroke-dasharray':'.',
                            'stroke-width':'3',
                            'stroke': "#ff0000"
                        }).toBack()
                        line.remove()
                        $('#timer > h3').hide()
                        $('.inside-buoys').show()
                    else
                        # Next
                        _this.trigger "step"

            line.transform "r" + mod*i + ","+@x+","+@y

            label.attr
                text: i + "°"
            if i < Math.abs deg
                i++
                setTimeout animateLine, 10
            else
                moveBoat()
        animateLine()

    makeMapStep: (model) =>
        dist = parseFloat model.get('distance') * 10
        deg = parseFloat model.get('degrees')
        if _.isNaN deg
            deg = 0
        ew = model.get('directionX')
        ns = model.get('directionY')

        @distanceTravelled += dist

        dist = -dist if ew == "west"
        mod = 1
        if ns == "south"
            label = @paper.text @x, @y + 20, 0
            if ew == "west"
                mod = -1
        else
            label = @paper.text @x, @y - 20, 0
            if ew == "east"
                mod = -1

        label.attr(
            'font-family':'Helvetica'
            'fill':'white'
            text: deg + "°"
        )

        ewLine = @paper.path("M" + @x + " " + @y + "L" + (@x + dist) + " " + @y)
        .attr
            "stroke-dasharray":'.'
            'stroke-width':'3'
            'stroke': '#fff'
        .toBack()
        ewLabelPos = ewLine.getPointAtLength(Math.abs dist)
        if ew == "east"
            ewLabel = @paper.text(ewLabelPos.x + 20, ewLabelPos.y, "E").attr(
                'font-family':'Helvetica'
                'fill':'white'
            )
        else
            ewLabel = @paper.text(ewLabelPos.x - 20, ewLabelPos.y, "W").attr(
                'font-family':'Helvetica'
                'fill':'white'
            )

        line = ewLine.clone().toBack()
        rotatedLine = @.paper.path(
            Raphael.transformPath(
                line.attr("path"), "r" + mod*deg + "," + @x + "," + @y
            )
        ).attr
            "stroke-dasharray":'.'
            'stroke-width':'3'
            'stroke': '#fff'
        target = rotatedLine.getPointAtLength(Math.abs dist)
        @x = target.x
        @y = target.y
        $("path").css 'opacity', 0.4
        # Check for boundary intersection
        s = Raphael.pathIntersection(
            @boundary.attr('path').toString()
            rotatedLine.attr('path').toString()
        )
        if s.length > 0
            @paper.path(rotatedLine.attr('path')).attr({
                'stroke-dasharray':'.',
                'stroke-width':'3',
                'stroke': "#ff0000"
            }).toBack()