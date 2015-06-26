# Captures +Contact+ information.
class ContactEntry
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  extend FormObject

  form_attributes(
    :city => String,
    :company_id => Integer,
    :contact_type => String,
    :country => String,
    :department_id => Integer,
    :description => String,
    :display_name => String,
    :email_address => String,
    :fax_number => String,
    :first_name => String,
    :initials => String,
    :is_active => Integer,
    :job_title => String,
    :last_name => String,
    :managing_contact_id => Integer,
    :managing_contact_name => String,
    :mobile_number => String,
    :office => String,
    :pager_number => String,
    :phone_number => String,
    :postal_code => String,
    :region => String,
    :street_address => String
  )

  validates \
    :display_name,
    :company_id,
    :department_id,
    :presence => true

  def active?
    is_active == 1
  end

  def companies
    Company.order { name }.to_a
  end

  def contact_types
    %w{group unknown user}
  end

  def departments
    return [] if company_id.nil?

    Department
      .where { company_id == my { company_id } }
      .order { name }
      .to_a
  end
end
