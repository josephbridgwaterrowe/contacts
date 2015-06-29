class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:contact_user)
      can :read, Contact
    end

    if user.has_role?(:contact_admin)
      can :create, Contact
      can :read, Contact
      can :update, Contact
    end

    if user.has_role?(:admin)
      can :manage, :all
    end
  end
end
