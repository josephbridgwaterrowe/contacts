class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.references :company, :null => false
      t.string :name, :null => false

      t.timestamps :null => false
    end
  end
end
