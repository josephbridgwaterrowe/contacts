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

  def location(contact)
    lines = []
    lines << contact.city unless contact.city.blank?
    lines << contact.region unless contact.region.blank?
    # lines << contact.postal_code unless contact.postal_code.blank?
    lines.join(', ')
  end

end
