class AddDoneField < ActiveRecord::Migration
  def up
    add_column :items, :done, :boolean, default: false
  end

  def down
    remove_column :items, :done
  end
end
