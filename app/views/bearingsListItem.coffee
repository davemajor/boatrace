module.exports = class BearingsListItemView extends Backbone.View
    className: 'bearingListItem'
    tagName: 'li'
    template: require 'views/templates/bearingsListItem'

    initialize: (options) ->
        @readonly = options.readonly
        @listenTo(@model, 'destroy', @remove)
        @listenTo(@model, 'invalid', @triggerInvalid)
        @listenTo(@model, 'valid', @triggerValid)

    render: ->
        $(@el).html @template
            distance: @model.get('distance')
            degrees: @model.get('degrees')
            directionX: @model.get('directionX')
            directionY: @model.get('directionY')
            readonly: @readonly
        @

    triggerInvalid: ->
        this.$el.addClass 'has-error'

    triggerValid: ->
        this.$el.removeClass 'has-error'

    clear: ->
        if Hipster.Collections.Bearings.length > 1
            @model.destroy()

    updateInput: (evt) ->
        @model.set evt.currentTarget.name, evt.currentTarget.value
        Hipster.Collections.Bearings.trigger 'redraw'

    events: ->
        'click .action-remove-item': "clear"
        'change input': 'updateInput'
        'keyup input': 'updateInput'
        'change select': 'updateInput'
        'click select': 'updateInput'

    window.Handlebars.registerHelper "select", (value, options) ->
        $el = $("<select />").html(options.fn(this))
        $el.find("[value=" + value + "]").attr selected: "selected"
        $el.html()
