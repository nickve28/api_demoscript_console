require './demo.rb'
require './authentication.rb'
require 'yaml'

config = YAML.load_file("./scenarios.yml")

Demo.new Auth, config
