class ContactsController < ApplicationController
  authorize_resource :contact

  def index
    # By default we want to exclude inactive contacts
    # And those that are no longer working?
    @search = Contact.
        where { is_active == 1 }.
        search(params[:q])
    results = @search.result(distinct: true).order { display_name }
    results = results.limit(params[:limit].to_i) unless params[:limit].blank? || params[:limit].to_i == 0

    @contacts = results.to_a

    @contacts_by_company = results.group_by { |contact| 
      contact.company.nil? || contact.company.strip.blank? ? 'No Company' : contact.company.strip 
    }

    respond_to do |format|
      format.html {}
      format.json {
        render json: @contacts.to_json( :methods => [:to_s] )
      }
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

end