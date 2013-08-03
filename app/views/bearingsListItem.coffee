module.exports = class BearingsListItemView extends Backbone.View
    className: 'bearingListItem'
    tagName: 'li'
    template: require 'views/templates/bearingsListItem'

    initialize: ->
        @listenTo(@model, 'destroy', @remove)

    render: ->
        $(@el).html @template
        @

    clear: ->
        if Hipster.Collections.Bearings.length > 1
            @model.destroy()

    updateInput: (evt) ->
        @model.set evt.currentTarget.name, evt.currentTarget.value

    events: ->
        'click .action-remove-item': "clear"
        'change input': 'updateInput'
        'keyup input': 'updateInput'
        'change select': 'updateInput'
        'click select': 'updateInput'