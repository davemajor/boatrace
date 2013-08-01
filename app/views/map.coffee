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
        _.each Hipster.Collections.Bearings.models, (bearing) =>
            if bearing.isValid()
                @steps.push @makeMovement bearing
            else
                bearing.destroy()
        if @steps.length > 0
            @startTime = new Date().getTime()
            @playing = true
            @timer = setTimeout @tick(), 100
            @drawStep()

    drawStep: ->
        attrs = {"stroke-dasharray":'.', 'stroke-width':'3', 'stroke': '#fff'}
        if @step < @steps.length
            $("path").css('opacity', 0.4)
            @paper.circle(@boat.attr("x") + 11, @boat.attr("y") + 12, 10).attr
                fill: "#0289FD"
                stroke: "none"
                opacity: "0.2"

            @paper.path(@steps[@step].path).attr attrs
            lastPath = @paper.path(@steps[@step].pathRadial).attr attrs
            @boat.animate(@steps[@step].animation).toFront()

            # s = Raphael.pathIntersection @boundary.attr('path').toString(),
            # @steps[@step].pathRadial

            # if s.length > 0
            #     @step = 'christ'
            #     lastPath.remove()
            #     @paper.path(@steps[@step].pathRadial).attr({
            #         'stroke-dasharray':'.',
            #         'stroke-width':'3',
            #         'stroke': "#ff0000"
            #     })

            @step++
        else
            @playing = false

    render: ->
        @paper = Raphael(@el, '100%', '100%')
        @reset()

    makeMovement: (model) ->
        dist = parseFloat model.get('distance')
        deg = parseFloat model.get('degrees')
        ew = model.get('directionX')
        ns = model.get('directionY')

        if ew == "east"
            path = Raphael.format("M{0} {1} L {2} {3}", @x, @y, @x + dist, @y)
            if ns == "north"
                newX = @x + dist * Math.sin((deg + 90) * Math.PI / 180)
                newY = @y + dist * Math.cos((deg + 90) * Math.PI / 180)
            else
                newX = @x + dist * Math.sin((90 - deg) * Math.PI / 180)
                newY = @y + dist * Math.cos((90 - deg) * Math.PI / 180)
        else
            path = Raphael.format("M{0} {1} L {2} {3}", @x, @y, @x - dist, @y)
            if ns == "north"
                newX = @x + dist * Math.sin((270 - deg) * Math.PI / 180)
                newY = @y + dist * Math.cos((270 - deg) * Math.PI / 180)
            else
                newX = @x + dist * Math.sin((deg + 270) * Math.PI / 180)
                newY = @y + dist * Math.cos((deg + 270) * Math.PI / 180)
        pathRadial = Raphael.format("M{0} {1} L {2} {3}", @x, @y, newX, newY)
        @x = newX
        @y = newY

        # Returns
        path: path
        pathRadial: pathRadial
        animation: Raphael.animation(
            x: newX - 11
            y: newY - 12
        , (dist / @speed) * 100, =>
            @trigger 'step'
        )