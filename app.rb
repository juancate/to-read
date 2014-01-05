require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require 'authlogic'

set :database, 'sqlite3:///read.db'
set :haml, format: :html5, layout: true

# Item model
class Item < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true, uniqueness: true
end

# User model
class User < ActiveRecord::Base
  acts_as_authentic
end

# Session model
class UserSesion < Authlogic::Session::Base
end

# Authentication helpers
helpers do
  def current_user_session
    return @current_user_session if defined? @current_user_session
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined? @current_user
    @current_user = current_user_session && current_user_session.user
  end
end

# Index
get '/' do
  @items = Item.where(done: false).order created_at: :asc
  @done_items = Item.where(done: true).order created_at: :asc
  haml :index
end

# Mark done
put '/:id/done' do
  item = Item.find params[:id]
  item.done = true

  redirect '/' unless item.save
end

# Create view
get '/add' do
  @title = 'Create'
  @action = '/items'
  @button_value = 'Save'
  @name_value = ''
  @link_value = ''

  haml :add
end

# Create
post '/items' do
  @item = Item.new params[:item]

  if @item.save
    redirect '/'
  else
    @title = 'Create'
    @action = '/items'
    @button_value = 'Save'
    haml :add
  end
end

# Edit view
get '/:id/edit' do
  @item = Item.find params[:id]
  @title = 'Edit'
  @action = "/items/#{@item.id}"
  @button_value = 'Edit'
  @name_value = @item.name
  @link_value = @item.link

  haml :add
end

# Delete
delete '/:id' do
  item = Item.find params[:id]

  redirect '/' unless item.destroy
end

# Edit
put '/items/:id' do
  @item = Item.find params[:id]
  if @item.update_attributes params[:item]
    redirect '/'
  else
    haml :add
  end
end

# Signup controller
get '/signup' do
  pass
end

# User session controller
get '/login' do
  haml :login
end

post '/login' do
  @user_session = UserSession.new params[:user_session]
  if @user_session.save
    haml :index
  else
    # Add flash message
    redirect '/login'
  end
end

get '/logout' do
  current_user_session.destroy
  redirect '/'
end
