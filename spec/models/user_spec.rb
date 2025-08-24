require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { User.new(valid_attributes) }

  let!(:department) do
    Department.create!(
      name: "Phòng Nhân sự",
      description: "Quản lý nhân sự"
    )
  end

  let(:valid_attributes) do
    {
      name: "Alice",
      email: "alice@example.com",
      role: :user,
      password: "123456",
      department: department,
      active: true
    }
  end

  before do
    department.reload
  end

  describe "associations" do
    it "belongs to department (optional)" do
      association = User.reflect_on_association(:department)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:optional]).to be true
    end

    it "has many sent_reports" do
      association = User.reflect_on_association(:sent_reports)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:class_name]).to eq("DailyReport")
      expect(association.options[:foreign_key]).to eq(:owner_id)
    end

    it "has many received_reports" do
      association = User.reflect_on_association(:received_reports)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:foreign_key]).to eq(:receiver_id)
    end
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(user).to be_valid
      expect(user.save).to be true
    end

    it "is invalid without a name" do
      user.name = nil
      expect(user.save).to be false
      expect(user.errors[:name]).to include("can't be blank")
    end

    it "is invalid if name is too long" do
      user.name = "a" * (Settings.MAX_LENGTH_USERNAME + 1)
      expect(user.save).to be false
      expect(user.errors[:name]).to include("is too long (maximum is #{Settings.MAX_LENGTH_USERNAME} characters)")
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user.save).to be false
      expect(user.errors[:email]).to include("can't be blank")
    end

    it "is invalid with wrong email format" do
      user.email = "invalid-email"
      expect(user.save).to be false
      expect(user.errors[:email]).to include("is invalid")
    end

    it "is invalid if email is not unique" do
      User.create!(valid_attributes)
      dup_user = User.new(valid_attributes.merge(name: "Another"))
      expect(dup_user.save).to be false
      expect(dup_user.errors[:email]).to include(I18n.t("users.errors.email_already_exists"))
    end
  end

  describe "delegations" do
    it "delegates department_name to department" do
      expect(user.department_name).to eq(department.name)
    end

    it "delegates manager to department" do
      manager = User.create!(valid_attributes.merge(name: "Manager", role: :manager))
      department.update!(manager: manager)
      expect(user.manager).to eq(manager)
    end

    it "delegates manager_name to manager" do
      manager = User.create!(valid_attributes.merge(name: "Manager", role: :manager))
      department.update!(manager: manager)
      expect(user.manager_name).to eq("Manager")
    end
  end

  describe "scopes" do
    let!(:admin)   { User.create!(valid_attributes.merge(email: "admin@example.com", role: :admin)) }
    let!(:manager) { User.create!(valid_attributes.merge(email: "manager@example.com", role: :manager)) }
    let!(:staff)   { User.create!(valid_attributes.merge(email: "staff@example.com", role: :user, active: true)) }
    let!(:inactive){ User.create!(valid_attributes.merge(email: "inactive@example.com", role: :user, active: false)) }

    it ".not_admin excludes admins" do
      expect(User.not_admin).not_to include(admin)
      expect(User.not_admin).to include(manager, staff, inactive)
    end

    it ".not_manager excludes managers" do
      expect(User.not_manager).not_to include(manager)
    end

    it ".active returns active users" do
      expect(User.active).to include(staff)
      expect(User.active).not_to include(inactive)
    end

    it ".inactive returns inactive users" do
      expect(User.inactive).to include(inactive)
    end

    it ".filter_by_active_status returns correct results" do
      expect(User.filter_by_active_status("active")).to include(staff)
      expect(User.filter_by_active_status("inactive")).to include(inactive)
      expect(User.filter_by_active_status("all")).to include(admin, manager, staff, inactive)
    end

    it ".filter_by_role filters by role" do
      expect(User.filter_by_role("manager")).to include(manager)
      expect(User.filter_by_role("manager")).not_to include(staff)
    end

    it ".filter_by_department filters by department_id" do
      dept2 = Department.create!(name: "Dept2", description: "This is description ......")
      u2 = User.create!(valid_attributes.merge(email: "u2@example.com", department: dept2))
      expect(User.filter_by_department(dept2.id)).to include(u2)
      expect(User.filter_by_department(dept2.id)).not_to include(staff)
    end

    it ".filter_by_email filters by email substring" do
      expect(User.filter_by_email("staff")).to include(staff)
      expect(User.filter_by_email("zzz")).to be_empty
    end
  end

  describe "custom validation: one_manager_per_department" do
    let!(:dept) { Department.create!(name: "Phòng IT", description: "Liên quan đến các vấn đề về CNTT") }

    it "allows only one manager per department" do
      User.create!(valid_attributes.merge(email: "m1@example.com", role: :manager, department: dept))
      another_manager = User.new(valid_attributes.merge(email: "m2@example.com", role: :manager, department: dept))

      expect(another_manager.save).to be false
      expect(another_manager.errors[:role]).to include(I18n.t("users.errors.one_manager_per_department"))
    end

    it "allows a manager if none exists in department" do
      manager = User.new(valid_attributes.merge(email: "m3@example.com", role: :manager, department: dept))
      expect(manager.save).to be true
    end
  end
end
