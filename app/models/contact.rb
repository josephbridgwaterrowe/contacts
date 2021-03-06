# Represents a Contact.
class Contact < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :address_book
  belongs_to :company
  belongs_to :department
  belongs_to :manager, class_name: Contact, foreign_key: :managing_contact_id

  validates :display_name, :presence => true

  def active?
    is_active.to_i == 1
  end

  def fax_number=(value)
    write_attribute(:fax_number, value ? value.gsub(/\D/, '') : nil)
  end

  def managing_contact_name
    return nil if manager.nil?

    manager.display_name
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
