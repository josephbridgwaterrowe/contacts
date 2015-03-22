class User < ActiveRecord::Base
  before_save :set_name

  devise :confirmable,
         :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable

  def active?
    self.is_active == 1
  end

  def active_for_authentication?
    super && active?
  end

  def has_role?(role_name, obj=nil)
    self.roles && self.roles.split(',').include?(role_name.to_s)
  end

  def set_name
    self.name = "#{first_name} #{last_name}".strip
  end
end
