module.exports = class RoutesCollection extends Backbone.Collection
    model: require 'models/route'
    url: 'http://testing.davemajor.net/boatrace/api/routes'
