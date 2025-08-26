class Abilities::UserAbility < Abilities::BaseAbility
  def define_abilities
    can :manage, DailyReport, owner_id: user.id
    cannot :index, :manager_daily_reports
    can :read, User, id: user.id
    can :read, :user_dashboard
  end
end
