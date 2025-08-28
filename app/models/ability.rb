class Ability
  include CanCan::Ability

  def initialize user
    return if user.blank?

    # Abilities for employee users
    Abilities::UserAbility.new(self, user).define_abilities if user.user?

    # Abilities for admin users
    Abilities::AdminAbility.new(self, user).define_abilities if user.admin?

    # Abilities for manager users
    Abilities::ManagerAbility.new(self, user).define_abilities if user.manager?
  end
end
