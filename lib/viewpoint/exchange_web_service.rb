module Viewpoint::EWS::SOAP
  class ExchangeWebService

    # Operation is used to create contact items
    # This is actually a CreateItem operation but they differ for different types
    # of Exchange objects so it is named appropriately here.
    # @see # http://msdn.microsoft.com/en-us/library/aa580529.aspx
    #
    # @param [String, Symbol] folder_id The folder to save this task in. Either a
    #   DistinguishedFolderId (must me a Symbol) or a FolderId (String)
    # @param [Hash, Array] items An array of item Hashes or a single item Hash. Hash
    #   values should be based on values found here: http://msdn.microsoft.com/en-us/library/aa581315.aspx
    #   This Hash will eventually be passed to add_hierarchy! in the builder so it is in that format.
    def create_contact_item(folder_id, items)
      action = "#{SOAP_ACTION_PREFIX}/CreateItem"
      resp = invoke("#{NS_EWS_MESSAGES}:CreateItem", action) do |node|
        build!(node) do
          # create_item!(folder_id, items, nil, false, 'contact')
          # create_item()
        end
      end
      parse!(resp)
    end

  end
end