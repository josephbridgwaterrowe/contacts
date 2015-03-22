require 'csv'

namespace :contact_manager do
  task :load_contacts_from_outlook_csv => :environment do

    files = Dir.glob('tmp/*.csv', File::FNM_CASEFOLD).entries.sort

    puts "Files: #{files.to_yaml}"

    files.each do |file_name|
      puts "Load contacts file: #{file_name}"

      CSV.foreach(file_name, :headers => true, :encoding => 'windows-1251:utf-8') do |row|
        # Only import SMTP records
        # next if row['E-mail Type'] != 'SMTP'

        if row['E-mail Type'] == 'SMTP'
          search_email_address = row['E-mail Address']
        elsif row['E-mail Type'] == 'EX'
          matches = row['E-mail Display Name'].match(/.*\((.*)\)/)

          search_email_address = matches[1] if matches && matches.size > 1
        end

        # puts "Find contact by #{search_email_address}"

        next if search_email_address.blank?

        # Look up the contact using their email address
        contact = Contact.where { email_address == my { search_email_address } }.first

        if contact.nil?
          # puts "No contact found for the email address #{row['E-mail Address']}"
        else
          puts "Contact found for the email address #{row['E-mail Address']}"
          puts "\t#{contact.display_name}"

          contact.company = row['Company']
          contact.job_title = row['Job Title']
          contact.street_address = row['Business Street']
          contact.city = row['Business City']
          contact.region = row['Business State']
          contact.postal_code = row['Business Postal Code']
          contact.phone_number = row['Business Phone']
          contact.fax_number = row['Business Fax']
          contact.mobile_number = row['Mobile Phone']
          contact.save!
        end

      end
    end

  end
end