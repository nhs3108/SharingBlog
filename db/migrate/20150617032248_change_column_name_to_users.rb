class ChangeColumnNameToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :actived, :activated
  end
end
