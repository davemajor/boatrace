@Hipster ?= {}
Hipster.Routers ?= {}
Hipster.Views ?= {}
Hipster.Models ?= {}
Hipster.Collections ?= {}

# Load App Helpers
require 'lib/helpers'

# Initialize Router
AppRouter = require 'routers/main'

$ ->
    # Initialize Backbone History
    Hipster.Routers.Main = new AppRouter
    Backbone.history.start pushState: yes