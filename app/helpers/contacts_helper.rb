module ContactsHelper
  def address(contact)
    lines = []
    lines << contact.street_address unless contact.street_address.blank?
    lines << contact.city unless contact.city.blank?
    lines << contact.region unless contact.region.blank?
    lines << contact.postal_code unless contact.postal_code.blank?
    lines << contact.country unless lines.empty? || contact.country.blank?
    lines.join(', ')
  end

  def add_contact_button
    return nil unless can?(:create, Contact)

    link_to 'Add Contact', new_configuration_contact_path,
            :class => 'btn btn-default'
  end

  def location(contact)
    lines = []
    lines << contact.city unless contact.city.blank?
    lines << contact.region unless contact.region.blank?
    # lines << contact.postal_code unless contact.postal_code.blank?
    lines.join(', ')
  end
end
