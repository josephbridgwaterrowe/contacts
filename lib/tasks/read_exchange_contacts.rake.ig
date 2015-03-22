require 'viewpoint'

namespace :contact_manager do
  task :read_exchange_contacts => :environment do
    include Viewpoint::EWS

    endpoint = "https://#{Figaro.env.EXCHANGE_HOST}/ews/Exchange.asmx"
    user = Figaro.env.EXCHANGE_USER
    pass = Figaro.env.EXCHANGE_PASS

    cli = Viewpoint::EWSClient.new endpoint, user, pass

    folder = cli.get_folder(:contacts)#, opts = {act_as: ''})

    puts folder.items.first.ews_item.to_yaml

    folder.items.each do |item|
      puts "Contact: #{item.complete_name}"#, #{item.display_name}"
    end

    # Viewpoint::EWS::EWS.endpoint = "https://#{Figaro.env.EXCHANGE_HOST}/ews/Exchange.asmx"
    # Viewpoint::EWS::EWS.set_auth Figaro.env.EXCHANGE_USER, Figaro.env.EXCHANGE_PASS
    # folder = Viewpoint::EWS::Folder.get_folder(:contacts)#, {act_as: ''})

    # puts folder
    #
    # items = folder.find_items
    #
    # items.each do |item|
    #   puts "Contact: #{item.file_as}"
    # end

    # Connect to exchange

    # Read contacts

  end

  task :put_exchange_contact => :environment do
    # include Viewpoint::EWS

    endpoint = "https://#{Figaro.env.EXCHANGE_HOST}/ews/Exchange.asmx"
    user = Figaro.env.EXCHANGE_USER
    pass = Figaro.env.EXCHANGE_PASS

    cli = Viewpoint::EWSClient.new endpoint, user, pass

    # folder = cli.get_folder(:calendar)
    #
    # puts folder.create_item()

    folder = cli.get_folder(:contacts)#, opts = {act_as: ''})#.to_yaml

    # result = folder.create_item(:display_name => 'Bob Smith', :given_name => 'Bob', :last_name => 'Smith')
    # result = folder.create_item(:file_as => 'Bob Smith (f)')
    result = folder.create_item(
        :given_name => 'Bob',
        :surname => 'Smith',
        :file_as => 'Bob Smith (f)')

    # Find the item using the result?

    # Update the item?

    # cli.update_item({:display_name => 'This is the display name (update item)'})

    puts result.to_yaml

  end

  task :update_exchange_contact => :environment do
    endpoint = "https://#{Figaro.env.EXCHANGE_HOST}/ews/Exchange.asmx"
    user = Figaro.env.EXCHANGE_USER
    pass = Figaro.env.EXCHANGE_PASS

    cli = Viewpoint::EWSClient.new endpoint, user, pass

    folder = cli.get_folder(:contacts)

    # Find a contact by email

    # Update an attributes

    # And update_item!

  end


  task :put_exchange_cal => :environment do
    include Viewpoint::EWS

    endpoint = "https://#{Figaro.env.EXCHANGE_HOST}/ews/Exchange.asmx"
    user = Figaro.env.EXCHANGE_USER
    pass = Figaro.env.EXCHANGE_PASS

    cli = Viewpoint::EWSClient.new endpoint, user, pass

    # folder = cli.get_folder(:calendar)
    #
    # puts folder.create_item()

    folder = cli.get_folder(:calendar)#, opts = {act_as: ''})#.to_yaml

    # result = folder.create_item(:display_name => 'Bob Smith', :given_name => 'Bob', :last_name => 'Smith')
    result = folder.create_item(:start => Time.now,
        :subject => 'Test Item')

    # Find the item using the result?

    # Update the item?

    # cli.update_item({:display_name => 'This is the display name (update item)'})

    puts result.to_yaml

    # Connect to exchange


    # Read contacts

  end

  # ---
  # :item_id:
  #     :attribs:
  #     :id:
  #     :change_key:
  # :has_attachments:
  #     :text: 'false'
  # :culture:
  #     :text: en-US
  # :file_as:
  #     :text:
  # :complete_name:
  #     :elems:
  #     - :first_name:
  #     :text:
  # - :last_name:
  #     :text:
  # - :full_name:
  #     :text:
  # :company_name:
  #     :text:
  # :email_addresses:
  #     :elems:
  #     - :entry:
  #     :attribs:
  #     :key: EmailAddress1
  # :text: "/o=/ou=cn=/cn=
  # :physical_addresses:
  #     :elems:
  #     - :entry:
  #     :attribs:
  #     :key: Business
  # :elems:
  #     - :street: {}
  # - :city: {}
  # - :state: {}
  # - :country_or_region: {}
  # - :postal_code: {}
  # - :entry:
  #     :attribs:
  #     :key: Home
  # :elems:
  #     - :street: {}
  # - :city: {}
  # - :state: {}
  # - :country_or_region: {}
  # - :postal_code: {}
  # :phone_numbers:
  #     :elems:
  #     - :entry:
  #     :attribs:
  #     :key: BusinessPhone
  # :text: ""
  # - :entry:
  #     :attribs:
  #     :key: HomePhone
  # :text: ""
  # - :entry:
  #     :attribs:
  #     :key: MobilePhone
  # :text: ""
  # :job_title:
  #     :text: ""
end
