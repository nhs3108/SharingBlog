class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.boolean :admin
      t.string :picture
      t.string :password_digest
      t.string :remember_digest
      t.string :activation_digest

      t.timestamps null: false
    end
  end
end
