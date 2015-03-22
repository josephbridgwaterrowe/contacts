class Company < ActiveRecord::Base
  has_many :departments

  validates :name, :presence => true, :uniqueness => true

  def to_s
    name
  end
end
