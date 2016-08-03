# Load the Rails application.
require_relative 'application'
require 'capybara/rails'
require 'capybara/rspec'

# Initialize the Rails application.
Rails.application.initialize!

Capybara.server_port = 8888 + ENV['TEST_ENV_NUMBER'].to_i