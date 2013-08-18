ResultsView = require 'views/resultsView'

module.exports = class MapView extends Backbone.View
    className: 'map'
    el: '.map'
    template: require 'views/templates/map'
    lineAttrs:
        'stroke':'white'
        'stroke-width':'3'
        "stroke-dasharray":'.'
        'opacity': '0.4'

    textAttrs:
        'font-family':'Helvetica'
        'fill':'white'

    initialize: ->
        @page = Hipster.Routers.Main.page
        @speed = 0.4
        @on 'reset', @reset, this
        if @page == 'page2'
            @on 'race', @race, this
            @on 'step', @drawStep, this
            $('button').attr 'disabled', 'disabled'
            @render()
            @renderPage2()
        else
            
            if @page == 'bretVictor'
                Hipster.Collections.Bearings.on 'redraw', =>
                    $('path').remove()
                    $('text').remove()
                    @drawScale()
                    @x = 100
                    @y = 100
                    @drawStep()
                , this
            else
                @on 'race', @race, this
                @on 'step', @drawStep, this
                @on 'tick', @tick, this

            @render()
            @reset()
    drawScale: ->
        @paper.path('M25 35 L125 35').attr(
            'stroke':'white'
            'stroke-width':'3'
            'opacity': '0.4'
        )
        @paper.text(75, 25, "10 miles").attr @textAttrs

    renderPage2: ->
        @x = 100
        @y = 100
        @reset()
        @boat = @paper.image("images/boat.png", @x-11, @y-12, 22, 24)
        @boat.node.classList.add('boat')
        $(@paper.canvas).on 'click tap', (evt) =>
            $('button').removeAttr 'disabled'
            if !@guessBoat?
                @guessBoat = @paper.image(
                    "images/boat.png"
                    evt.clientX-11,
                    evt.clientY-12,
                    22,
                    24
                )
            else
                @guessBoat.attr(
                    x: evt.clientX-11,
                    y: evt.clientY-12
                )

    reset: ->
        $('.error').hide()
        if @page == 'page2'
            $('button').attr 'disabled', 'disabled'
        if @guessBoat?
            @guessBoat.remove()
            @guessBoat = undefined
        clearTimeout(@timer)
        $('.boat').remove()
        $('.buoy').remove()
        $('circle').remove()
        $('text').remove()
        $('path').remove()

        @drawScale()
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
        @boat.node.classList.add('boat')

        if  @page == 'bretVictor'
            @endZone = @paper.circle(
                @boat.attr('x') + 11
                @boat.attr('y') + 12
                40
            ).attr(
                "fill": "white"
                "opacity": 0.2
                "stroke": "none"
            )
        if @page != 'page2'
            @drawBuoys([
                {x: 140, y: 150},
                {x: 260, y: 500},
                {x: 450, y: 580},
                {x: 560, y: 300},
                {x: 360, y: 100}]
            )

    drawBuoys: (buoys) ->
        _.each buoys, (buoy) =>
            b = @paper.image("images/buoy.png", buoy.x-12, buoy.y-12, 25, 25)
            b.node.classList.add 'buoy'
        @boundary = @paper.path 'M{0} {1} L{2} {3} {4} {5} {6} {7} {8} {9}z',
        buoys[0].x, buoys[0].y, buoys[1].x, buoys[1].y,
        buoys[2].x, buoys[2].y, buoys[3].x, buoys[3].y,
        buoys[4].x, buoys[4].y
        @boundary.attr
            'stroke': 'none'
        $(@boundary.node).addClass 'boundary'

    tick: ->
        if @playing
            @time += 100
            @elapsed = Math.floor(@time / 1000) / 10
            @elapsed += ".0"  if Math.round(@elapsed) is @elapsed
            if @page == 'page1'
                Hipster.Views.TimerView.trigger 'update', @elapsed
            diff = (new Date().getTime() - @startTime) - @time
            @timer = setTimeout(=> @trigger 'tick', (100 - diff))

    race: ->
        $('button').attr 'disabled', 'disabled'
        if !Hipster.Collections.Bearings.models[0].isValid()
            return
        if @page != 'page2'
            @reset()
        if @page != 'bretVictor'
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
        if @page != 'bretVictor'
            if @step < Hipster.Collections.Bearings.length
                if Hipster.Collections.Bearings.models[@step].isValid()
                    $("path").css('opacity', 0.4)
                    b = @paper.image(
                        "images/boat.png"
                        @boat.attr("x")
                        @boat.attr("y")
                        22
                        24
                    ).attr
                        opacity: 0.4
                    b.node.classList.add('boat')
                    @makeMovement Hipster.Collections.Bearings.at @step
                else
                    @playing = false
                    @check()
                @step++
            else
                @playing = false
                if @page == 'page2'
                    @checkPage2()
                else
                    @check()
        else
            debugger
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

    checkPage2: ->
        deltaX = @boat.attr().x - @guessBoat.attr().x
        deltaY = @boat.attr().y - @guessBoat.attr().y

        delta = Math.sqrt(Math.pow(deltaY, 2) + Math.pow(deltaX, 2))
        delta = (delta / 10).toFixed(1)
        Hipster.Views.BearingsListView.close()
        Hipster.Views.ResultsView = new ResultsView
            distance: delta

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
            Hipster.Views.ResultsView = new ResultsView
        else
            $('#timer > h3').hide()
            $('.missed').show()
            $('button').removeAttr 'disabled'


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

        label.attr @textAttrs

        ewLine = @paper.path("M" + @x + " " + @y + "L" + (@x + dist) + " " + @y)
        .attr @lineAttrs
        ewLine.toBack()
        ewLabelPos = ewLine.getPointAtLength(Math.abs dist)
        if ew == "east"
            ewLabel = @paper.text(ewLabelPos.x + 20, ewLabelPos.y, "E").attr(
                @textAttrs
            )
        else
            ewLabel = @paper.text(ewLabelPos.x - 20, ewLabelPos.y, "W").attr(
                @textAttrs
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
                , Math.abs(dist) / _this.speed, =>
                    _this.x = target.x
                    _this.y = target.y
                    ewLine.remove()
                    ewLabel.remove()
                    $("path").css 'opacity', 0.4

                    if _this.page == 'page2'
                        _this.trigger "step"
                    else
                        # Check for boundary intersection
                        doesIntersect = @checkForIntersect(
                            _this.boundary.attr('path').toString()
                            rotatedLine.attr('path').toString()
                        )
                        if doesIntersect
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

    checkForIntersect: (boundary, line) ->
        s = Raphael.pathIntersection boundary, line
        return s.length > 0

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

        label.attr @textAttrs
        label.attr
            text: deg + "°"

        ewLine = @paper.path("M" + @x + " " + @y + "L" + (@x + dist) + " " + @y)
        ewLine.attr @lineAttrs
        ewLine.toBack()
        ewLabelPos = ewLine.getPointAtLength(Math.abs dist)
        if ew == "east"
            ewLabel = @paper.text(ewLabelPos.x + 20, ewLabelPos.y, "E").attr(
                @textAttrs
            )
        else
            ewLabel = @paper.text(ewLabelPos.x - 20, ewLabelPos.y, "W").attr(
                @textAttrs
            )

        line = ewLine.clone().toBack()
        rotatedLine = @.paper.path(
            Raphael.transformPath(
                line.attr("path"), "r" + mod*deg + "," + @x + "," + @y
            )
        ).attr @lineAttrs

        target = rotatedLine.getPointAtLength(Math.abs dist)
        @x = target.x
        @y = target.y
        $("path").css 'opacity', 0.4
        if @page != 'page2'
            # Check for boundary intersection
            doesIntersect = @checkForIntersect(
                @boundary.attr('path').toString()
                rotatedLine.attr('path').toString()
            )
            if doesIntersect
                @paper.path(rotatedLine.attr('path')).attr({
                    'stroke-dasharray':'.',
                    'stroke-width':'3',
                    'stroke': "#ff0000"
                }).toBack()
    close: ->
        $(@el).empty()
        $(@el).unbind()