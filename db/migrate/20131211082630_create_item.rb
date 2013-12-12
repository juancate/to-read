class CreateItem < ActiveRecord::Migration
  def up
    create_table :items do |i|
      i.string :name
      i.string :link
      i.timestamps
    end

    Item.create(name: "Obscure C++ Features",
                link: "http://madebyevan.com/obscure-cpp-features/?viksra")
    Item.create(name: "Sinatra and Active Record",
                link: "http://www.danneu.com/posts/15-a-simple-blog-with-sinatra-and-active-record-some-useful-tools/")
  end

  def down
    drop_table :items
  end
end
