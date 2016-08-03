require "selenium/webdriver"

 # Capybara.register_driver :chrome do |app|
 #   profile = Selenium::WebDriver::Chrome::Profile.new
 #   profile["download.default_directory"] = DownloadHelpers::PATH.to_s
 #   profile['webdriver.load.strategy'] = 'unstable'
 #   # profile["profile.default_content_settings"] = {:images => '2'}
 #   Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
 # end

Capybara::Webkit.configure do |config|
  # Enable debug mode. Prints a log of everything the driver is doing.
  config.debug = false
  config.ignore_ssl_errors

  # Don't load images
  config.skip_image_loading

end

Capybara.default_max_wait_time = 40
Capybara.javascript_driver = :selenium
Capybara.default_driver = :webkit

# Capybara.register_driver :poltergeist_debug do |app|
#   options = {
#       phantomjs_options: ['--load-images=no'],
#       js_errors: true,
#       phantomjs_logger: Logger.new(STDOUT)
#   }
#   Capybara::Poltergeist::Driver.new(app,options)
# end

# Capybara.register_driver :firefox do |app|
#   profile = Selenium::WebDriver::Firefox::Profile.new
#   profile['webdriver.load.strategy'] = 'unstable'
#   Capybara::Selenium::Driver.new(app, :browser => :firefox, profile: profile)
# end

# Capybara.default_driver = :poltergeist
#
# Capybara.javascript_driver = :selenium

# Capybara.default_driver = :poltergeist
