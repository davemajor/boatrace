module.exports = class RoutesCollection extends Backbone.Collection
    model: require 'models/route'
    url: '/api/routes'
