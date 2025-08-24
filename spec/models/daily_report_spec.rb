require "rails_helper"

RSpec.describe DailyReport, type: :model do
  let(:department) do
    Department.create!(
      name: "Phòng Kiểm tra",
      description: "Xử lý các vấn đề kỹ thuật và bảo trì hệ thống"
    )
  end

  let(:owner) do
    User.create!(
      name: "John",
      email: "john@example.com",
      role: :manager,
      password: "123456",
      department: department
    )
  end

  let(:different_owner) do
    User.create!(
      name: "Different Owner",
      email: "different@example.com",
      role: :user,
      password: "123456",
      department: department
    )
  end

  let(:receiver) do
    User.create!(
      name: "Jane",
      email: "jane@example.com",
      role: :user,
      password: "123456",
      department: department
    )
  end

  let(:valid_attributes) do
    {
      owner: owner,
      receiver: receiver,
      report_date: Date.current,
      planned_tasks: "Complete feature A implementation and testing",
      actual_tasks: "Finished feature A development and unit testing",
      next_day_planned_tasks: "Start feature B development and code review"
    }
  end

  let(:daily_report) { DailyReport.new(valid_attributes) }

  before do
    Department.update_all(manager_id: nil)
    [DailyReport, User, Department].each(&:delete_all)

    department.update!(manager: owner)
  end

  def create_report(attrs = {})
    DailyReport.create!(valid_attributes.merge(attrs))
  end

  describe "enum status methods" do
    let(:report) { create_report(status: :pending) }

    it "responds to status_pending?" do
      expect(report.status_pending?).to be true
    end

    it "responds to status_read?" do
      report.update!(status: :read)
      expect(report.status_read?).to be true
    end
  end

  describe "associations" do
    it "belongs to owner" do
      association = DailyReport.reflect_on_association(:owner)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to receiver" do
      association = DailyReport.reflect_on_association(:receiver)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "enum status" do
    it "defines correct status values" do
      expected_statuses = Settings.daily_report_status.to_h.keys.map(&:to_s)
      expect(DailyReport.statuses.keys).to match_array(expected_statuses)
    end
  end

  describe "validations" do
    context "when attributes are valid" do
      it "creates report successfully" do
        expect(daily_report).to be_valid
        expect(daily_report.save).to be true
      end
    end

    describe "planned_tasks" do
      context "when too short" do
        it "is invalid" do
          daily_report.planned_tasks = "short"
          daily_report.save
          expect(daily_report.errors[:planned_tasks].size).to eq(1)
          expect(daily_report.errors[:planned_tasks]).to include("is too short (minimum is 20 characters)")
        end
      end

      context "when exactly 20 characters" do
        it "is valid" do
          daily_report.planned_tasks = "a" * 20
          daily_report.save
          expect(daily_report.errors[:planned_tasks]).to be_empty
          expect(daily_report).to be_valid
        end
      end

      context "when more than 20 characters" do
        it "is valid" do
          daily_report.planned_tasks = "Complete feature implementation, write unit tests, and do code review"
          daily_report.save
          expect(daily_report).to be_valid
        end
      end
    end

    describe "actual_tasks" do
      context "when too short" do
        it "is invalid" do
          daily_report.actual_tasks = "done"
          daily_report.save
          expect(daily_report.errors[:actual_tasks].size).to eq(1)
          expect(daily_report.errors[:actual_tasks]).to include("is too short (minimum is 20 characters)")
        end
      end

      context "when valid length" do
        it "is valid" do
          daily_report.actual_tasks = "Successfully completed feature A development and testing"
          daily_report.save
          expect(daily_report.errors[:actual_tasks]).to be_empty
          expect(daily_report).to be_valid
        end
      end
    end

    describe "next_day_planned_tasks" do
      context "when too short" do
        it "is invalid" do
          daily_report.next_day_planned_tasks = "next task"
          daily_report.save
          expect(daily_report.errors[:next_day_planned_tasks].size).to eq(1)
          expect(daily_report.errors[:next_day_planned_tasks]).to include("is too short (minimum is 20 characters)")
        end
      end

      context "when valid length" do
        it "is valid" do
          daily_report.next_day_planned_tasks = "Start new feature B development and initial planning"
          daily_report.save
          expect(daily_report.errors[:next_day_planned_tasks]).to be_empty
          expect(daily_report).to be_valid
        end
      end
    end

    describe "report_date" do
      context "when blank" do
        it "is invalid" do
          daily_report.report_date = nil
          daily_report.save
          expect(daily_report.errors[:report_date].size).to eq(1)
          expect(daily_report.errors[:report_date]).to include("can't be blank")
        end
      end

      context "when current date" do
        it "is valid" do
          daily_report.report_date = Date.current
          daily_report.save
          expect(daily_report).to be_valid
        end
      end

      context "when past date" do
        it "is valid" do
          daily_report.report_date = 1.week.ago
          daily_report.save
          expect(daily_report).to be_valid
        end
      end
    end

    describe "unique report per day" do
      let(:report_date) { Date.current }

      before do
        create_report(owner: owner, report_date: report_date)
      end

      context "when owner creates duplicate report on same date" do
        it "is invalid" do
          duplicate_report = DailyReport.new(valid_attributes.merge(
            owner: owner,
            report_date: report_date
          ))
          duplicate_report.save
          expect(duplicate_report.errors[:report_date].size).to eq(1)
          expect(duplicate_report.errors[:report_date]).to include(
            "You have already submitted a report for this date. Please update it instead."
          )
        end
      end

      context "when same owner creates report on different date" do
        it "is valid" do
          different_date_report = DailyReport.new(valid_attributes.merge(
            owner: owner,
            report_date: report_date + 1.day
          ))
          different_date_report.save
          expect(different_date_report).to be_valid
        end
      end

      context "when different owner creates report on same date" do
        it "is valid" do
          same_date_report = DailyReport.new(valid_attributes.merge(
            owner: different_owner,
            report_date: report_date
          ))
          same_date_report.save
          expect(same_date_report).to be_valid
        end
      end

      context "when updating existing report" do
        it "is valid" do
          existing_report = DailyReport.find_by(owner: owner, report_date: report_date)
          existing_report.planned_tasks = "Updated planned tasks for today's work"
          existing_report.save
          expect(existing_report).to be_valid
          expect(existing_report.save).to be true
        end
      end
    end
  end

  describe "scopes" do
    let!(:pending_report) { create_report(status: :pending, report_date: Date.current) }
    let!(:read_report) { create_report(status: :read, report_date: 1.day.ago) }
    let!(:commented_report) { create_report(status: :commented, report_date: 2.days.ago) }

    describe ".order_created_at_desc" do
      it "returns reports in descending creation order" do
        expected_order = [commented_report, read_report, pending_report]
        expect(DailyReport.order_created_at_desc.to_a).to eq(expected_order)
      end
    end

    describe ".by_status" do
      it "returns reports with given status" do
        expect(DailyReport.by_status("pending")).to include(pending_report)
        expect(DailyReport.by_status("pending")).not_to include(read_report, commented_report)
      end
    end

    describe ".by_report_date" do
      it "returns reports for given date" do
        expect(DailyReport.by_report_date(Date.current)).to include(pending_report)
        expect(DailyReport.by_report_date(Date.current)).not_to include(read_report, commented_report)
      end
    end

    describe ".by_owner_id" do
      it "returns reports for given owner" do
        reports = DailyReport.by_owner_id(owner.id)
        expect(reports).to include(pending_report, read_report, commented_report)
      end
    end

    describe ".filter_by_report_date" do
      it "returns reports for given date" do
        expect(DailyReport.filter_by_report_date(Date.current)).to include(pending_report)
        expect(DailyReport.filter_by_report_date(Date.current)).not_to include(read_report, commented_report)
      end
    end

    describe ".filter_by_status" do
      it "returns reports with given status" do
        expect(DailyReport.filter_by_status(:read)).to include(read_report)
        expect(DailyReport.filter_by_status(:read)).not_to include(pending_report, commented_report)
      end
    end

    describe ".filter_by_owner" do
      it "returns reports for given owner" do
        reports = DailyReport.filter_by_owner(owner.id)
        expect(reports).to include(pending_report, read_report, commented_report)
      end
    end

    describe ".count_by_status_pending" do
      it "returns correct pending count for receiver" do
        expected_count = DailyReport.where(status: :pending, receiver: receiver).count
        expect(DailyReport.count_by_status_pending(receiver)).to eq(expected_count)
      end
    end

    describe ".in_month" do
      it "returns reports within given month" do
        date = Date.current
        expected_reports = DailyReport.where(
          report_date: date.beginning_of_month..date.end_of_month
        )
        expect(DailyReport.in_month(date)).to match_array(expected_reports)
      end
    end
  end
end
