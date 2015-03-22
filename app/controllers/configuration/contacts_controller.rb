class Configuration::ContactsController < ApplicationController
  authorize_resource :contact

  before_filter :populate_lists

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to(configuration_contact_path(@contact), notice: 'Contact created')
    else
      render :new
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    if @contact.destroy
      redirect_to(configuration_contacts_path(), notice: 'Contact removed')
    else
      redirect_to(configuration_contacts_path(), notice: 'Contact not removed')
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def index
    if params[:q] == nil
      params[:q] = { :is_active_eq => 1 }
    end

    query_params = params[:q].clone

    # No company filtering hack, implement a nice way of doing this... 
    # for instance, populate the company with No Company during import.
    if query_params[:company_eq] && query_params[:company_eq] == 'No Company'
      query_params.delete(:company_eq)
      query_params[:company_blank] = 1
    end

    # By default we want to exclude inactive contacts
    # And those that are no longer working?
    @search = Contact.search(query_params)
    results = @search.result(distinct: true).order { display_name }
    results = results.limit(params[:limit].to_i) unless params[:limit].blank? || params[:limit].to_i == 0

    @contacts = results.to_a
  end

  def new
    @contact = Contact.new
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      redirect_to(configuration_contact_path(@contact), notice: 'Contact updated')
    else
      render :edit
    end
  end

  private

  def contact_params
    params.
        require(:contact).
        permit(:contact_type,
               :description,
               :first_name,
               :initials,
               :last_name,
               :office,
               :display_name,
               :email_address,
               :pager_number,
               :phone_number,
               :mobile_number,
               :fax_number,
               :street_address,
               :city,
               :region,
               :state,
               :postal_code,
               :company,
               :department,
               :job_title,
               :managing_contact_id,
               :is_active)

  end

  def populate_lists
    @active_inactive_list = [[:active, 1], [:inactive, 0]]
    @contact_types = %w{group unknown user}
    @company_list = Contact.select { company }.
      map { |x| x.company.nil? || x.company.strip.blank? ? 'No Company' : x.company.strip }.
      uniq.
      sort
  end


end
