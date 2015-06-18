class AddActivedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :actived, :boolean
  end
end
