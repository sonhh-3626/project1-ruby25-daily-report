class Department < ApplicationRecord
  belongs_to :manager, class_name: User.name, optional: true

  has_many :users, dependent: :nullify
  has_many :daily_reports, through: :users, source: :sent_reports

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description,
            presence: true,
            length: {minimum: Settings.MIN_LENGTH_DESCRIPTION_10}

  DEPARTMENT_PARAMS = %w(name description).freeze

  scope :order_by_latest, ->{order(created_at: :desc)}
  scope :order_by_name, ->{order(name: :desc)}
  scope :search_by_name, lambda do |query|
    if query.present?
      where("name LIKE ?", "%#{query.strip}%")
    end
  end
end
