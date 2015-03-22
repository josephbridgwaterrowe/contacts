module Viewpoint::EWS::Types
  class ContactsFolder
    include Viewpoint::EWS
    include Viewpoint::EWS::Types
    include Viewpoint::EWS::Types::GenericFolder

    # Creates a new appointment
    # @param attributes [Hash] Parameters of the calendar item. Some example attributes are listed below.
    # @option attributes :subject [String]
    # @return [Contact]
    # @see Template::Contact
    def create_item(attributes)
      template = Viewpoint::EWS::Template::Contact.new attributes
      template.saved_item_folder_id = {id: self.id, change_key: self.change_key}
      puts "Create: #{template.to_ews_create}"
      rm = ews.create_item(template.to_ews_create).response_messages.first
      puts "Rm: #{rm}"
      puts "Rm success? #{rm.success?}"
      if rm && rm.success?
        Contact.new ews, rm.items.first[:contact][:elems].first
      else
        puts "Raise error: Could not create item in folder. #{rm.code}: #{rm.message_text}"
        raise EwsCreateItemError, "Could not create item in folder. #{rm.code}: #{rm.message_text}" #unless rm
      end
    end
  end

end