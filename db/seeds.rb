User.delete_all
Department.delete_all

departments = [
  Department.create!(name: "Phòng Kỹ thuật", description: "Xử lý các vấn đề kỹ thuật và bảo trì hệ thống"),
  Department.create!(name: "Phòng Kinh doanh", description: "Quản lý khách hàng và hoạt động kinh doanh"),
  Department.create!(name: "Phòng Hành chính", description: "Quản lý nhân sự, hành chính"),
  Department.create!(name: "Phòng IT", description: "Quản lý hệ thống mạng, phần mềm, phần cứng")
]

10.times do |i|
  User.create!(
    name: "Nhân viên #{i + 1}",
    email: "user#{i + 1}@example.com",
    role: 0,
    password: "123456",
    department: departments.sample
  )
end

User.create!(
  name: "Admin 1",
  email: "admin@gmail.com",
  role: 2,
  password: "123456"
)

manager = User.create!(
  name: "Quản lý 1",
  email: "manager1@example.com",
  role: 1,
  password: "123456",
  department: departments.first
)

manager.managed_departments << departments[0..2]
