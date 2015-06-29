# +FormObject+ module.
#
# Depends on Virtus for model attributes.
module FormObject
  def form_attributes(attribute_hash)
    attribute_hash.each do |key, value|
      attribute key, value
    end
  end
end
