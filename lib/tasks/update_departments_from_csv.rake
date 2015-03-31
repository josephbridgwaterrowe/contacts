require 'csv'

namespace :contacts do
  desc 'Loads contact company and department information from a CSV file'
  task(
    :load_departments_from_csv,
    [:path] => :environment) do |_t, args|
    CSV.foreach(args.path, :headers => true) do |row|
      company = Company.find_by(:name => row['company_name'])

      fail "Company #{row['company_name']} was not found for #{row.to_yaml}" \
        if company.nil?

      department = Department.find_by(:company_id => company.id, :name => row['department_name'])

      fail "Department #{row['department_name']} was not found." \
        if department.nil?

      username = row['email_address'].split('@')[0]

      contact = Contact.where { email_address =~ "#{username}%" }.first

      fail "Contact #{row['email_address']} was not found." if contact.nil?

      puts "Updating contact #{contact.display_name}"

      contact.company = company
      contact.department = department
      contact.save!
    end
  end
end
