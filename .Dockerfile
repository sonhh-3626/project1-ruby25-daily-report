# Sử dụng base image Ruby phiên bản 3.2
FROM ruby:3.2-slim

# Cài đặt các package hệ thống cần thiết cho Rails và MySQL client
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    default-mysql-client \
    yarn \
    tzdata \
    dos2unix

USER sonha

# Thiết lập thư mục làm việc bên trong container
WORKDIR /app

# Copy Gemfile trước để tận dụng cache, giúp build image nhanh hơn ở những lần sau
COPY Gemfile Gemfile.lock ./

# Cài đặt các gem
RUN bundle install

# Copy toàn bộ mã nguồn vào container
COPY . .

# Expose cổng 3000 để bên ngoài có thể truy cập vào ứng dụng Rails
EXPOSE 3000

# Lệnh mặc định sẽ chạy khi container khởi động
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
