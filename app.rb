require 'sinatra'
require 'sinatra/activerecord'
require 'haml'

set :database, 'sqlite3:///read.db'
set :haml, format: :html5, layout: true

class Item < ActiveRecord::Base
  validates :name, presence: true
  validates :link, presence: true, uniqueness: true
end

# Index
get '/' do
  @items = Item.where(done: false).order created_at: :asc
  @done_items = Item.where(done: true).order created_at: :asc
  haml :index
end

# Mark done
put '/:id/done' do
  item = Item.find(params[:id])
  item.done = true

  if item.save
    redirect '/'
  end
end

# Create view
get '/add' do
  @title = "Create"
  @action = "/items"
  @button_value = "Save"
  @name_value = ""
  @link_value = ""

  haml :add
end

# Create
post '/items' do
  @item = Item.new(params[:item])

  if @item.save
    redirect '/'
  else
    @title = "Create"
    @action = "/items"
    @button_value = "Save"
    haml :add
  end
end

# Edit view
get '/:id/edit' do
  @item = Item.find(params[:id])
  @title = "Edit"
  @action = "/items/#{@item.id}"
  @button_value = "Edit"
  @name_value = @item.name
  @link_value = @item.link

  haml :add
end

# Delete view
get '/:id/delete' do
  @item = Item.find(params[:id])

  if @item
    @action = "/#{@item.id}"
    haml :delete
  end
end

# Delete
delete '/:id' do
  @item = Item.find(params[:id])

  if @item.destroy
    redirect '/'
  end
end

# Edit
put '/items/:id' do
  @item = Item.find(params[:id])
  if @item.update_attributes(params[:item])
    redirect '/'
  else
    haml :add
  end
end
