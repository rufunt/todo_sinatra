require 'sinatra'
require 'sequel'

class Todo < Sinatra::Application
  set :environment, ENV['RACK_ENV']
  
  configure do
    env = ENV['RACK_ENV']
    DB = Sequel.connect(YAML.load(File.open('database.yml'))[env]) 

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }
    Dir[File.join(File.dirname(__FILE__),'lib','*.rb')].each { |lib| load lib }
    enable :sessions
  end

end

