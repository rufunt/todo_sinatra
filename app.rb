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
    user = User.first(id: session[user_id])
    list = List.first(id: params[:id])
    can_change_permission = true

    if list.nil?
      can_change_permission = false
    elsif list.shared_with != 'public'
      permission = Permission.first(list: list, user: user)
      if permission.nil? or permission.permission_level == 'read_only'
        can_change_permission = false
      end
    end

    if can_change_permission
      list.permission_level = params[:new_permissions]
      list.save

      current_permissions = Permission.first(list: list)
      current_permissions.each do |perm|
        perm.destroy
      end

      if params[:new_permissions] == 'private' or params[:new_permissions] == 'shared'
        user_perms.each do |perm|
          u = User.first(perm[:user])
          Permission.create(list: list, user: u, permission_level: perm[:level], created_at: Time.now, updated_at: Time.now)
        end
      end

      redirect request.referer
    else
      haml :error, locals: {error: 'Invalid permissions'}
    end
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