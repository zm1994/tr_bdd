# require "selenium/webdriver"
#
#  # Capybara.register_driver :chrome do |app|
#  #   profile = Selenium::WebDriver::Chrome::Profile.new
#  #   profile["download.default_directory"] = DownloadHelpers::PATH.to_s
#  #   profile['webdriver.load.strategy'] = 'unstable'
#  #   # profile["profile.default_content_settings"] = {:images => '2'}
#  #   Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)
#  # end
#
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end
#
# Capybara::Webkit.configure do |config|
#   # Enable debug mode. Prints a log of everything the driver is doing.
#   config.debug = false
#   config.ignore_ssl_errors
#
#   # Don't load images
#   config.skip_image_loading
#
# end
#
# Capybara.default_max_wait_time = 50
# Capybara.javascript_driver = :selenium
# Capybara.default_driver = :webkit
#
$root_path_avia = 'https://tripway.stb/avia'
$root_path_railway = 'https://tripway.stb/railway'
$root_path_mobile_avia = 'https://tripway.stb/?mobile=1'
$array_web_mobile_root_path = [$root_path_avia, $root_path_mobile_avia]