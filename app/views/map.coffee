module.exports = class MapView extends Backbone.View
    className: 'map'
    el: '.map'
    template: require 'views/templates/map'

    initialize: ->
        @speed = 20
        @x = 100
        @y = 100
        @steps = []
        @step = 0
        @time = 0
        @elapsed = 0
        @render()
        @timer = 0
        @playing = false
        @startTime = 0

        @on 'race', @race, this
        @on 'step', @drawStep, this
        @on 'tick', @tick, this

    reset: ->
        clearTimeout(@timer)
        @paper.clear()
        @steps = []
        @x = 100
        @y = 100
        @time = 0
        @elapsed = 0
        @step = 0
        @boat = @paper.image("images/dot.png", @x-11, @y-12, 22, 24)

        buoys = [
            {x: 140, y: 150},
            {x: 260, y: 400},
            {x: 350, y: 480},
            {x: 460, y: 300}
        ]
        _.each buoys, (buoy) =>
            @paper.circle buoy.x, buoy.y, 10

        @boundary = @paper.path 'M{0} {1} L{2} {3} {4} {5} {6} {7}z',
        buoys[0].x, buoys[0].y, buoys[1].x, buoys[1].y,
        buoys[2].x, buoys[2].y, buoys[3].x, buoys[3].y

    tick: ->
        if @playing
            @time += 100
            @elapsed = Math.floor(@time / 1000) / 10
            @elapsed += ".0"  if Math.round(@elapsed) is @elapsed
            Hipster.Views.TimerView.trigger 'update', @elapsed
            diff = (new Date().getTime() - @startTime) - @time
            @timer = setTimeout(=> @trigger 'tick', (100 - diff))

    race: ->
        @reset()
        
        @startTime = new Date().getTime()
        @playing = true
        @timer = setTimeout @tick(), 100
        @drawStep()

    drawStep: ->
        attrs = {"stroke-dasharray":'.', 'stroke-width':'3', 'stroke': '#fff'}

        if @step < Hipster.Collections.Bearings.length
            $("path").css('opacity', 0.4)
            @paper.circle(@boat.attr("x") + 11, @boat.attr("y") + 12, 10).attr
                fill: "#0289FD"
                stroke: "none"
                opacity: "0.2"

            @makeMovement Hipster.Collections.Bearings.at @step

            @step++
        else
            @playing = false

    render: ->
        @paper = Raphael(@el, '100%', '100%')
        @reset()

    makeMovement: (model) =>
        dist = parseFloat model.get('distance')
        deg = parseFloat model.get('degrees')
        ew = model.get('directionX')
        ns = model.get('directionY')

        label = @paper.text @x, @y, 0

        dist = -dist if ew == "west"
        mod = 1
        if ns == "south"
            if ew == "west"
                mod = -1
        else
            if ew == "east"
                mod = -1

        ewLine = @paper.path("M" + @x + " " + @y + "L" + (@x + dist) + " " + @y)
        .attr
            "stroke-dasharray":'.'
            'stroke-width':'3'
            'stroke': '#fff'
        .toBack()
        ewLabelPos = ewLine.getPointAtLength(Math.abs dist)
        if ew == "east"
            ewLabel = @paper.text(ewLabelPos.x + 20, ewLabelPos.y, "E")
        else
            ewLabel = @paper.text(ewLabelPos.x - 20, ewLabelPos.y, "W")
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
                        })
                    else
                        # Next
                        _this.trigger "step"

            line.transform "r" + mod*i + ","+@x+","+@y

            i++
            label.attr "text", i + "°"
            if i < Math.abs deg
                setTimeout animateLine, 10
            else
                moveBoat()
        animateLine()