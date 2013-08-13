module.exports = class BearingsListItemView extends Backbone.View
    className: 'bearingListItem'
    tagName: 'li'
    template: require 'views/templates/bearingsListItem'

    initialize: ->
        @listenTo(@model, 'destroy', @remove)
        @listenTo(@model, 'invalid', @triggerInvalid)
        @listenTo(@model, 'valid', @triggerValid)

    render: ->
        $(@el).html @template @model.toJSON()
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