require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/avia_booking_helper'
require 'support/avia_test_data_helper'

describe 'Admin panel tests for cities in admin' do
  include AdminAuthHelper
  include AviaBooking

  random = Random.new
  search_round = DataRoundSearch.new

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'avia_booking_sms_packages')
  end

  it 'create new sms package' do
    visit($root_path_admin + 'avia_booking_sms_packages/new?market_code=ua')
    sms_package_name = 'test' + random.rand(10...1000).to_s
    find('#avia_booking_sms_package_name_ua_ru').set sms_package_name
    find('#avia_booking_sms_package_name_ua_ua').set sms_package_name
    sms_amount = random.rand(10...300)
    find('#avia_booking_sms_package_price').set sms_amount
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    # check on the booking page visibility new sms package
    visit($root_path_avia)
    try_open_booking_page_for_regular($url_recommendation_round,
                                      search_round.type_avia_search,
                                      search_round.params_avia_location,
                                      search_round.params_flight_dates,
                                      search_round.params_passengers)
    expect(page).to have_selector('.order_form__package_name', text: sms_package_name)
  end

  it 'create sms package on ru market' do
    visit($root_path_admin + 'avia_booking_sms_packages/new?market_code=ru')
    sms_package_name = 'test' + random.rand(10...1000).to_s
    find('#avia_booking_sms_package_name_ru_ru').set sms_package_name
    sms_amount = random.rand(10...300)
    find('#avia_booking_sms_package_price').set sms_amount
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    # check on the booking page ru market visibility new sms package
    visit($root_path_avia + '/ru')
    try_open_booking_page_for_regular($url_recommendation_round,
                                      search_round.type_avia_search,
                                      search_round.params_avia_location,
                                      search_round.params_flight_dates,
                                      search_round.params_passengers)
    expect(page).to have_selector('.order_form__package_name', text: sms_package_name)
  end

  it 'create sms package and disable on the site' do
    visit($root_path_admin + 'avia_booking_sms_packages/new?market_code=ua')
    sms_package_name = 'test' + random.rand(10...1000).to_s
    find('#avia_booking_sms_package_name_ua_ru').set sms_package_name
    find('#avia_booking_sms_package_name_ua_ua').set sms_package_name
    sms_amount = random.rand(10...300)
    find('#avia_booking_sms_package_price').set sms_amount
    # disable checkbox on the enabling on the site
    find('#avia_booking_sms_package_site_enabled').click
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    # check on the booking page ru market visibility new sms package
    visit($root_path_avia)
    try_open_booking_page_for_regular($url_recommendation_round,
                                      search_round.type_avia_search,
                                      search_round.params_avia_location,
                                      search_round.params_flight_dates,
                                      search_round.params_passengers)
    expect(page).not_to have_selector('.order_form__package_name', text: sms_package_name)
  end
end