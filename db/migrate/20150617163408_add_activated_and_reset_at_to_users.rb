class AddActivatedAndResetAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activated_at, :datetime
    add_column :users, :reset_at, :datetime
  end
end
