class Department < ActiveRecord::Base
  belongs_to :company

  validates :company, :name, :presence => true

  def to_s
    name
  end
end
