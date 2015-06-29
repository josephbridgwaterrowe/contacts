# Service object to create a new +Contact+.
class CreateContact
  include Interactor

  before :build_contact
  before :validate

  def call
    context.contact.save
    context.message = I18n.t('contacts.contact.create.success')
  end

  def build_contact
    context.contact = Contact.new(params)
    context.contact.address_book = AddressBook.first
  end

  def params
    context
      .to_h
      .slice(:contact_type,
             :description,
             :first_name,
             :initials,
             :last_name,
             :office,
             :display_name,
             :email_address,
             :pager_number,
             :phone_number,
             :mobile_number,
             :fax_number,
             :street_address,
             :city,
             :region,
             :state,
             :postal_code,
             :company_id,
             :department_id,
             :company,
             :department,
             :company_name,
             :department_name,
             :job_title,
             :managing_contact_id,
             :is_active)
  end

  def validate
    return if context.contact.valid?

    context.fail!(:message => I18n.t('contacts.contact.create.invalid'))
  end
end
