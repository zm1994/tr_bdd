require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/auth_helper'
require 'support/mobile_avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/mobile_avia_booking_helper'
require 'support/mobile_booking_service_helper'

describe 'Mobile page avia order for round search' do
  # include MobileAviaSearch
  # include MobileAviaBooking
  include AuthHelper
  include MobileBookingService

  search_round = DataRoundSearch.new

  before do
    visit($root_path_mobile_avia)
    unless $url_mobile_page_booking_round_regular.empty?
      visit($url_mobile_page_booking_round_regular)
    else
      open_mobile_booking_page_round(search_round)
    end
  end

  it 'check regular booking without input data', retry: 3 do
    find('.order_form__button_role-submit').click
    expect(page).to have_selector('.field_with_errors')
    expect(page.current_url == $url_mobile_page_booking_round_regular).to be(true)
  end

  it 'check availability to autorization and choose first passenger passenger usual user in regular booking', retry: 3 do
    auth_from_booking_page('test@example.com', 'qwerty123', true)
    # click and check first passenger from dropdown list
    expect(page).to have_selector('.avia_order_form')
    first('[data-class="Avia.PassengersDropdown"]').click
    first('.profile_passengers__item').click
    expect(first('.avia_order_journey_item_element_documents_firstname input').value.length > 0).to be(true)
  end

  it 'check availability to autorization with agent email in regular booking', retry: 3 do
    auth_from_booking_page('test@test.ua', 'test123', true)
    # check after autorization will bу new search
    expect(page).to have_selector('.trip_search__progressbar_indicator_done')
    check_aviability_regular_recommendations
  end

  it 'check fare rules' do
    # find first fare rule end check content
    check_mobile_fare_rules
  end
end