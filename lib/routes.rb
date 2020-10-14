require 'sinatra'

class Todo < Sinatra::Base

  get '/' do
    'App is running!'
  end

end