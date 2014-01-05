require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require 'authlogic'

enable :sessions
set :session_secret, 'super secret'
set :database, 'sqlite3:///read.db'
set :haml, format: :html5, layout: true
I18n.enforce_available_locales = true

# Item model
class Item < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true, uniqueness: true
  belongs_to :user
end

# User model
class User < ActiveRecord::Base
  acts_as_authentic
  has_many :items
end

# Session model
class UserSession < Authlogic::Session::Base
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
  return haml :login unless current_user_session

  @items = Item.where done: false, user_id: current_user.id
  @items = @items.order created_at: :asc
  @done_items = Item.where done: true, user_id: current_user.id
  @done_items = @done_items.order created_at: :asc
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
  @item.user_id = current_user.id

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
  haml :register
end

post '/signup' do
  @user = User.new params[:user]

  if @user.save
    # Flash message
    redirect '/'
  else
    redirect '/register'
  end
end

# User session controller
get '/login' do
  @user_session = UserSession.new
  haml :login
end

post '/login' do
  @user_session = UserSession.new params[:user_session]
  if @user_session.save
    redirect '/'
  else
    # Add Flash message
    redirect '/login'
  end
end

get '/logout' do
  current_user_session.destroy
  redirect '/'
end
