class Abilities::BaseAbility
  attr_reader :ability, :user

  def initialize ability, user
    @ability = ability
    @user = user
    define_abilities
  end

  def define_abilities; end

  def can(*args)
    ability.can(*args)
  end

  def cannot(*args)
    ability.cannot(*args)
  end
end
