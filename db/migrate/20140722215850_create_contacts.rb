class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :address_book, null: false
      t.string :first_name
      t.string :last_name
      t.string :initials
      t.string :display_name
      t.string :description
      t.string :office
      t.string :email_address

      t.string :phone_number
      t.string :pager_number
      t.string :fax_number
      t.string :mobile_number

      t.string :street_address
      t.string :city
      t.string :region
      t.string :postal_code
      t.string :country

      t.string :job_title
      t.string :department
      t.string :company

      t.integer :is_active, default: 1, null: false
      t.integer :managing_contact_id

      # t.datetime :start_date
      # t.datetime :finish_date
      # t.string :finish_reason

      t.string :external_reference
      t.string :external_source

      t.datetime :deleted_at
      t.timestamps :null => false
    end
  end
end
