require 'sinatra'
require 'sinatra/activerecord'
require 'haml'
require 'authlogic'
require 'rack-flash'

enable :sessions
set :session_secret, 'super secret'

set :database, 'sqlite3:///read.db'
set :sever, :puma
set :haml, format: :html5, layout: true
I18n.enforce_available_locales = true

use Rack::Flash

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
  return haml :login unless current_user

  @items = Item.where(done: false, user_id: current_user.id)
               .order(created_at: :asc)

  @done_items = Item.where(done: true, user_id: current_user.id)
                    .order(created_at: :asc)
  haml :index
end

# Mark done
put '/:id/done' do
  item = Item.find(params[:id])
  item.done = true

  redirect '/' unless item.save
end

# Create view
get '/add' do
  redirect '/' unless current_user_session
  @title = 'Create'
  @action = '/items'
  @button_value = 'Save'
  @name_value = ''
  @link_value = ''

  haml :add
end

# Create
post '/items' do
  @item = Item.new(params[:item])
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
  redirect '/' unless current_user_session

  @item = Item.find(params[:id])
  @title = 'Edit'
  @action = "/items/#{@item.id}"
  @button_value = 'Edit'
  @name_value = @item.name
  @link_value = @item.link

  haml :add
end

# Delete
delete '/:id' do
  item = Item.find(params[:id])

  redirect '/' unless item.destroy
end

# Edit
put '/items/:id' do
  @item = Item.find(params[:id])

  if @item.update_attributes(params[:item])
    redirect '/'
  else
    redirect "/#{params[:id]}/edit"
  end
end

# Signup controller
get '/signup' do
  redirect '/' if current_user_session
  haml :register
end

post '/signup' do
  @user = User.new(params[:user])

  if @user.save
    flash[:notice] = 'Successfully signed up.'
    redirect '/'
  else
    flash[:error] = { bold: 'Something went wrong.',
                      body: 'Please try again.' }
    redirect '/register'
  end
end

# User session controller
get '/login' do
  redirect '/' if current_user_session
  @user_session = UserSession.new
  haml :login
end

post '/login' do
  @user_session = UserSession.new(params[:user_session])
  if @user_session.save
    flash[:notice] = 'Successfully logged in.'
    redirect '/'
  else
    flash[:error] = { bold: 'Something went wrong.',
                      body: 'Please try again.' }
    redirect '/login'
  end
end

get '/logout' do
  current_user_session.destroy
  redirect '/'
end
