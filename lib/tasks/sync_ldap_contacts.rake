require 'net/ldap'

namespace :contact_manager do
  task :pull_ldap_contacts => :environment do
    # Start by using Figaro to load contact details
    # And then we will configure the OU sources in the DB and front end

    ldap = Net::LDAP.new
    ldap.host = Figaro.env.LDAP_HOST
    ldap.port = 389
    ldap.auth Figaro.env.LDAP_USER, Figaro.env.LDAP_PASS
    if ldap.bind
      # authentication succeeded
      puts 'success'

      # filter = Net::LDAP::Filter.eq( "cn", "*" )
      filter = Net::LDAP::Filter.eq( 'objectclass', 'user' ) &
          Net::LDAP::Filter.eq( 'objectcategory', 'person' ) &
          Net::LDAP::Filter.eq( 'mail', '*' )
      tree_base = 'dc=westernmilling,dc=com'

      ldap.search(:base => tree_base, :filter => filter) do |entry|
        puts "DN: #{entry.dn}"
        puts "\t\tEmail: #{entry[:mail].first}"
        # puts "DN: #{entry.displayname}"
        # entry.each do |attribute, values|
        #   puts "   #{attribute}:"
        #   values.each do |value|
        #     puts "      --->#{value}"
        #   end
        # end

        contact = Contact.with_deleted.where { email_address == my { entry[:mail].first } }.first

        if contact.nil?
          contact = Contact.new
          contact.address_book = AddressBook.first
          contact.email_address = entry[:mail].first
        end

        contact.first_name = entry[:givenname].first
        contact.initials = get_ldap_value(entry[:initials])
        contact.last_name = entry[:sn].first
        contact.display_name = entry[:displayname].first
        contact.description = get_ldap_value(entry[:description])
        contact.phone_number = get_ldap_value(entry[:homePhone])
        contact.mobile_number = get_ldap_value(entry[:mobile])
        contact.fax_number = get_ldap_value(entry[:facsimileTelephoneNumber])
        contact.pager_number = get_ldap_value(entry[:pager])
        contact.street_address = entry[:streetaddress].first if entry[:streetaddress].any?
        contact.city = entry[:l].first if entry[:l].any?
        contact.region = entry[:st].first if entry[:st].any?
        contact.postal_code = entry[:postalcode].first if entry[:postalcode].any?
        contact.country = get_ldap_value(entry[:co])
        contact.job_title = entry[:title].first if entry[:title].any?
        contact.department = entry[:department].first if entry[:department].any?
        contact.company = entry[:company].first if entry[:company].any?
        contact.external_reference = entry.dn
        contact.external_source = 'ldap'

        # TODO: Look up the manager
        manager_dn = entry[:manager].first

        manager = Contact.
            where { external_source == :ldap.to_s }.
            where { external_reference == my { manager_dn } }.
            first
        contact.manager = manager

        contact.save!
      end
    else
      # authentication failed
      puts 'failed'
    end
  end

  task :push_ldap_contacts => :environment do
    # Start by using Figaro to load contact details
    # And then we will configure the OU sources in the DB and front end

    ldap = Net::LDAP.new
    ldap.host = Figaro.env.LDAP_HOST
    ldap.port = 389
    ldap.auth Figaro.env.LDAP_USER, Figaro.env.LDAP_PASS
    if ldap.bind
      # authentication succeeded
      puts 'success'

      contacts = Contact.
          where { external_source == :ldap.to_s }.
          # where { department == 'IT' }.
          to_a

      contacts.each do |contact|
        puts "Updating contact: #{contact.external_reference}"

        ops = []
        ops << get_ldap_replace(:givenname, contact.first_name)
        ops << get_ldap_replace(:initials, contact.initials)
        ops << get_ldap_replace(:sn, contact.last_name)
        ops << get_ldap_replace(:displayname, contact.display_name)
        ops << get_ldap_replace(:description, contact.description)
        ops << get_ldap_replace(:mail, contact.email_address)
        ops << get_ldap_replace(:homePhone, contact.phone_number)
        ops << get_ldap_replace(:mobile, contact.mobile_number)
        ops << get_ldap_replace(:facsimileTelephoneNumber, contact.fax_number)
        ops << get_ldap_replace(:pager, contact.pager_number)
        ops << get_ldap_replace(:streetAddress, contact.street_address)
        ops << get_ldap_replace(:l, contact.city)
        ops << get_ldap_replace(:st, contact.region)
        ops << get_ldap_replace(:postalcode, contact.postal_code)
        ops << get_ldap_replace(:co, contact.country)
        ops << get_ldap_replace(:title, contact.job_title)
        ops << get_ldap_replace(:department, contact.department)
        ops << get_ldap_replace(:company, contact.company)
        manager_dn = contact.manager.external_reference if contact.manager
        ops << get_ldap_replace(:manager, manager_dn)

        puts "Ops: #{ops.inspect}"

        success = ldap.modify(:dn => contact.external_reference, :operations => ops) if ops.any?

        puts "Success: #{success}"

      end

    else
      # authentication failed
      puts 'failed'
    end
  end

  def get_ldap_value(attribute)
    if attribute.any?
      attribute.first
    else
      nil
    end
  end

  def get_ldap_replace(name, value)
    [:replace, name, value.blank?? [] : value]
  end

end
