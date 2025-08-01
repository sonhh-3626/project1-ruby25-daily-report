class User < ApplicationRecord
  belongs_to :department, optional: true
  has_many :managed_departments,
           class_name: Department.name,
           foreign_key: :manager_id,
           dependent: :nullify
  has_many :sent_reports,
           class_name: DailyReport.name,
           foreign_key: :owner_id,
           dependent: :destroy
  has_many :received_reports,
           class_name: DailyReport.name,
           foreign_key: :receiver_id,
           dependent: :nullify

  enum role: Settings.user_role.to_h

  USER_PARAMS = %w(name email role department_id)

  scope :filter_by_email, ->(email){where("email LIKE ?", "%#{email}%") if email.present?}
  scope :filter_by_role, ->(role){where(role: role) if role.present?}
  scope :filter_by_department, ->(department_id){where(department_id: department_id) if department_id.present?}
end
