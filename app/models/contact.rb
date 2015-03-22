class Contact < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :address_book
  belongs_to :manager, class_name: Contact, foreign_key: :managing_contact_id

  def active?
    is_active.to_i == 1
  end

  def fax_number=(value)
    write_attribute(:fax_number, value ? value.gsub(/\D/, '') : nil)
  end

  def mobile_number=(value)
    write_attribute(:mobile_number, value ? value.gsub(/\D/, '') : nil)
  end

  def pager_number=(value)
    write_attribute(:pager_number, value ? value.gsub(/\D/, '') : nil)
  end

  def phone_number=(value)
    write_attribute(:phone_number, value ? value.gsub(/\D/, '') : nil)
  end

  def position_string
    lines = []
    lines << job_title unless job_title.blank?
    lines << department unless department.blank?
    lines.join(', ')
  end

  def to_s
    display_name
  end
end
