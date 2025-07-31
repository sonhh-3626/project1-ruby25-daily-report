class Department < ApplicationRecord
  belongs_to :manager, class_name: User.name, optional: true

  has_many :users, dependent: :nullify
  has_many :daily_reports, through: :users, source: :sent_reports
end
