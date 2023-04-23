require "bundler/setup"
require "hanami/api"
require "pg"
require "hanami/middleware/body_parser"


require_relative 'app'

run App.new