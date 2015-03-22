class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :null => false, :default => ''
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :name, null: false
      t.integer :is_active, default: 1, null: false
      t.string :roles
      t.string :provider
      t.string :uid

      t.datetime :remember_created_at
      t.string :remember_token

      t.string :reset_password_token
      t.datetime :resent_password_sent_at

      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip
    end

    add_index :users, :email, :unique => true
  end
end
