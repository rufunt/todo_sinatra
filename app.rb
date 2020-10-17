require 'sinatra'
require 'sequel'

class Todo < Sinatra::Application
  

  configure do
    DB = Sequel.connect("mysql2://root:4791@localhost/todo") 

    Dir[File.join(File.dirname(__FILE__),'models','*.rb')].each { |model| require model }
  end

  
  get '/?' do
    all_lists = List.all
    haml :lists, locals: {lists: all_lists}
  end

  get '/new/?' do
    haml :new_list
  end

  post '/new/?' do
    user = User.first(name: session[:user_id])
    List.new_list params[:title], params[:items], user
    redirect request.referer
  end

  get '/edit/:id/?' do
    list = List.first(id: params[:id])
    can_edit = true

    if list.nil?
      can_edit = false
    elsif list.shared_with == 'public'
      user = User.first(id: session[:user_id])
      permission = Permission.first(list: list, user: user)
      if permission.nil? or permission_level == 'read_only'
        can_edit = false
      end
    end

    if can_edit
      haml :edit_list, locals: {list: list}
    else
      haml ;error, locals: {error: 'Invalid permissions'}
    end
  end

  post '/edit/?' do
    user = User.first(id: session[:user_id)]
    List.edit_list params[:id], params[:name], params[:items], user
    redirect request.referer
  end

  post '/permission/?' do
    # update permission
  end

  get '/signup/?' do
    # show signup form 
  end

  post '/signup/?' do
    # save the user data
  end

  get '/login/?' do
    # show a login page 
  end

  post '/login/?' do
    # validate user
  end

end