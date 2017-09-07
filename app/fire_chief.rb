require 'sinatra/base'
require 'slack-ruby-client'

require_relative './server'
require_relative './controllers/api'
require_relative './controllers/auth'
require_relative './models/events'
