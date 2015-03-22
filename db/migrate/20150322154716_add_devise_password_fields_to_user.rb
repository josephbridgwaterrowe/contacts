class AddDevisePasswordFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :created_at, :datetime, :null => false
    add_column :users, :deleted_at, :datetime
    add_column :users, :updated_at, :datetime, :null => false
    add_column :users, :encrypted_password, :string, :null => false

    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    add_index :users, :confirmation_token, :unique => true
  end
end
