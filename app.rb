require 'sinatra'
require 'sequel'

class Todo < Sinatra::Application
  
  configure do
    DB = Sequel.connect("mysql2://root:4791@localhost/todo") 

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }
    Dir[File.join(File.dirname(__FILE__),'lib','*.rb')].each { |lib| load lib }
    enable :sessions
  end

end

