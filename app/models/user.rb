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
end
