module.exports = class TimerView extends Backbone.View
    el: '#timer'
    template: require 'views/templates/timer'

    initialize: ->
        @on 'update', @render
        @render(null)

    render: (time) ->
        $('#timer').html @template
            time: time
