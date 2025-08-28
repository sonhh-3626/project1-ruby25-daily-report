class Abilities::ManagerAbility < Abilities::BaseAbility
  def define_abilities
    can :manage, DailyReport, owner: {department_id: user.department_id}
    can :read, User, department_id: user.department_id
    can :read, Department, id: user.department_id
    can :read, :manager_dashboard
  end
end
