Department.update_all(manager_id: nil)
DailyReport.delete_all
User.delete_all
Department.delete_all

# Tạo phòng ban
departments = [
  Department.create!(name: "Phòng Kỹ thuật", description: "Xử lý các vấn đề kỹ thuật và bảo trì hệ thống"),
  Department.create!(name: "Phòng Kinh doanh", description: "Quản lý khách hàng và hoạt động kinh doanh"),
  Department.create!(name: "Phòng Hành chính", description: "Quản lý nhân sự, hành chính"),
  Department.create!(name: "Phòng IT", description: "Quản lý hệ thống mạng, phần mềm, phần cứng")
]

# Admin
User.create!(
  name: "Admin 1",
  email: "admin@gmail.com",
  role: :admin,
  password: "123456"
)

5.times do |i|
  User.create!(
    name: "Nhân viên #{i + 1}",
    email: "user#{i + 1}@example.com",
    role: :user,
    password: "123456",
    department: departments.first
  )
end
