class AddCompanyAndDepartmentToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :company_id, :integer
    add_column :contacts, :department_id, :integer
    rename_column :contacts, :company, :company_name
    rename_column :contacts, :department, :department_name
  end
end
