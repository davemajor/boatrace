@Hipster ?= {}
Hipster.Routers ?= {}
Hipster.Views ?= {}
Hipster.Models ?= {}
Hipster.Collections ?= {}

# Load App Helpers
require 'lib/helpers'

# Initialize Router
require 'routers/main'

AppView = require 'views/appView'

$ ->
    # Initialize Backbone History
    Backbone.history.start pushState: yes
    Hipster.Views.AppView = new AppView

