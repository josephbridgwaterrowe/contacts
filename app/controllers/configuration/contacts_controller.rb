class Configuration::ContactsController < ApplicationController
  authorize_resource :contact

  before_action :find_contact, :only => [:destroy, :edit, :show, :update]
  before_action :build_contact_entry, :only => [:create, :edit, :new, :update]
  before_action :populate_lists

  def create
    return render :new unless @contact_entry.valid?

    context = CreateContact.call(contact_params)

    if context.success?
      redirect_to(contact_path(context.contact), :notice => context.message)
    else
      flash[:alert] = context.message
      render :new
    end
  end

  def destroy
    if @contact.destroy
      redirect_to(configuration_contacts_path(),
        :notice => t('contacts.contact.destroy.success'))
    else
      redirect_to(configuration_contacts_path(),
        :notice => t('contacts.contact.destroy.failure'))
    end
  end

  def edit; end

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

  def show; end

  def update
    return render :edit unless @contact_entry.valid?

    if @contact.update_attributes(contact_params)
      redirect_to(configuration_contact_path(@contact.id),
                  :notice => t('contacts.contact.update.success'))
    else
      render :edit
    end
  end

  private

  def build_contact_entry
    @contact_entry =  ContactEntry.new(
      (@contact || Contact.new)
        .attributes
        .symbolize_keys
        .slice(*param_keys)
        .merge(contact_params)
    )
  end

  def contact_params
    params.
        require(:contact_entry).
        permit(param_keys)
  rescue ActionController::ParameterMissing; {}
  end

  def find_contact
    @contact = Contact.find(params[:id])
  end

  def param_keys
    [
      :contact_type,
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
      :managing_contact_name,
      :fax_number,
      :street_address,
      :city,
      :region,
      :state,
      :postal_code,
      :company_id,
      :department_id,
      :company,
      :department,
      :company_name,
      :department_name,
      :job_title,
      :managing_contact_id,
      :is_active
    ]
  end

  def populate_lists
    @active_inactive_list = [[:active, 1], [:inactive, 0]]
    @contact_types = %w{group unknown user}
    @company_list = Contact.select { company_name }.
      map { |x| x.company_name.nil? || x.company_name.strip.blank? ? 'No Company' : x.company_name.strip }.
      uniq.
      sort
  end
end
