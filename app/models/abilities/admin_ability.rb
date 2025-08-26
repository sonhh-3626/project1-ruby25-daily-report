class Abilities::AdminAbility < Abilities::BaseAbility
  def define_abilities
    can :manage, :all
    can :read, :admin_dashboard
  end
end
