class AddContactTypeToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :contact_type, :string, :default => 'unknown', :null => false
  end
end
