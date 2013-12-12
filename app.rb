require 'sinatra'
require 'sinatra/activerecord'
require 'haml'

set :database, 'sqlite3:///read.db'
set :haml, :format => :html5

class Item < ActiveRecord::Base
end

# Index
get '/' do
  #@items = Item.all
  @items = Item.order("created_at ASC")
  haml :index, :layout => :layout
end

# Create view
get '/add' do
  @action = "/items"
  @button_value = "Save"
  @name_value = ""
  @link_value = ""

  haml :add, :layout => :layout
end

# Create
post '/items' do
  @item = Item.new(params[:item])

  if @item.save
    redirect '/'
  else
    haml :add, :layout => :layout
  end
end

# Edit view
get '/:id/edit' do
  @item = Item.find(params[:id])
  @action = "/items/#{@item.id}"
  @button_value = "Edit"
  @name_value = @item.name
  @link_value = @item.link

  haml :add, :layout => :layout
end

# Delete view
get '/:id/delete' do
  @item = Item.find(params[:id])

  if @item
    @action = "/#{@item.id}"
    haml :delete, :layout => :layout
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
    haml :add, :layout => :layout
  end
end
