class ItemUsers < ActiveRecord::Migration
  def up
    add_column :items, :user_id, :integer, default: 1
  end

  def down
    remove_column :items, :user_id
  end
end
