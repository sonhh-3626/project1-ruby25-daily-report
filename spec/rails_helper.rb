require "simplecov"
require "simplecov-rcov"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

class SimpleCov::Formatter::MergedFormatter
  def format(result)
    SimpleCov::Formatter::HTMLFormatter.new.format(result)
    SimpleCov::Formatter::RcovFormatter.new.format(result)
  end
end

SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
SimpleCov.start "rails"
