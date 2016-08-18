require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/search_helper'
require 'support/booking_helper'
require 'support/test_data_helper'

describe 'Page avia order for round search' do
  include AviaSearch
  include AviaBooking
  include AuthHelper
  include TestData

  search = DataRoundSearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers

  before do
    visit($dev_root_path)
  end

  it 'check regular booking without input data', retry: 3 do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    find('.avia_order_form__button_role-submit').click
    expect(page).to have_selector('.field_with_errors')
    expect(page.current_url == $url_page_booking_round_regular).to be(true)
  end

  it 'check availability to autorization and choose first passenger passenger usual user in regular booking', retry: 3 do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    auth_from_booking_page('test@example.com', 'qwerty123')
    # click and check first passenger from dropdown list
    expect(page).to have_selector('.avia_order_form')
    first('[data-class="Avia.PassengersDropdown"]').click
    first('.avia_order_form_passengers_dropdown__menu_item_link').click
    expect(first('.avia_order_journey_item_element_documents_firstname input').value.length > 0).to be(true)
  end

  it 'check availability to autorization with agent email in regular booking', retry: 3 do
    if $url_page_booking_round_regular.length > 0
      visit($url_page_booking_round_regular)
    else
      $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    auth_from_booking_page('test@test.ua', 'test123')
    # check after autorization will bу new search
    expect(page).to have_selector('.avia_trip_search__progressbar_indicator')
    check_aviability_lowcosts_and_redular
  end

  it 'check availability to autorization and choose first passenger passenger usual user in lowcost', retry: 3 do
    if $url_page_booking_round_lowcost.length > 0
      visit($url_page_booking_round_lowcost)
    else
      $url_page_booking_round_lowcost = try_open_booking_page_for_lowcost($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    end
    auth_from_booking_page('test@example.com', 'qwerty123')
    # click and check first passenger from dropdown list
    expect(page).to have_selector('.avia_order_form')
    first('[data-class="Avia.PassengersDropdown"]').click
    first('.avia_order_form_passengers_dropdown__menu_item_link').click
    expect(first('.avia_kiwi_order_journey_item_element_documents_firstname input').value.length > 0).to be(true)
  end
end