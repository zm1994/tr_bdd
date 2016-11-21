require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/auth_helper'
require 'support/mobile_avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/mobile_avia_booking_helper'

describe 'Mobile page avia order for round search' do
  include MobileAviaSearch
  include MobileAviaBooking
  include AuthHelper
  # include TestData

  search = DataRoundSearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers

  before do
    visit($root_path_mobile_avia)
    params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
    params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
  end

  it 'check regular booking without input data', retry: 3 do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    find('.order_form__button_role-submit').click
    expect(page).to have_selector('.field_with_errors')
    expect(page.current_url == $url_page_booking_round_regular).to be(true)
  end

  it 'check availability to autorization and choose first passenger passenger usual user in regular booking', retry: 3 do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    auth_from_booking_page('test@example.com', 'qwerty123', true)
    # click and check first passenger from dropdown list
    expect(page).to have_selector('.avia_order_form')
    first('[data-class="Avia.PassengersDropdown"]').click
    first('.profile_passengers__item').click
    expect(first('.avia_order_journey_item_element_documents_firstname input').value.length > 0).to be(true)
  end

  it 'check availability to autorization with agent email in regular booking', retry: 3 do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    auth_from_booking_page('test@test.ua', 'test123', true)
    # check after autorization will bу new search
    expect(page).to have_selector('.trip_search__progressbar_indicator_done')
    check_aviability_regular_recommendations
  end

  it 'check fare rules' do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end

    # find first fare rule end check content
    first('.section__fare_rules_link').click
    check_fare_rules
  end
end