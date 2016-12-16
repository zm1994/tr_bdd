require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/avia_booking_service_helper'

describe 'Page avia order for round search' do
  include AviaSearch
  include AviaBooking
  include AuthHelper
  include AviaBookingService

  search_round = DataRoundSearch.new

  before do
    visit($root_path_avia)
    search_round.params_flight_dates[:date_departure] = increase_date_flight(search_round.params_flight_dates[:date_departure])
    search_round.params_flight_dates[:date_arrival] = increase_date_flight(search_round.params_flight_dates[:date_arrival])

    unless ($url_page_booking_round_regular.empty?)
      visit($url_page_booking_round_regular)
    else
      open_booking_page_round(search_round)
    end
  end

  it 'check regular booking without input data', retry: 3 do
    find('.order_form__button_role-submit').click
    expect(page).to have_selector('.field_with_errors')
    expect(page.current_url == $url_page_booking_round_regular).to be(true)
  end

  it 'check availability to autorization and choose first passenger passenger usual user in regular booking', retry: 3 do
    auth_from_booking_page('test@example.com', 'qwerty123')
    # click and check first passenger from dropdown list
    expect(page).to have_selector('.avia_order_form')
    first('[data-class="Avia.PassengersDropdown"]').click
    first('.order_form_passengers_dropdown__menu_item_link').click
    expect(first('.avia_order_journey_item_element_documents_firstname input').value.empty?).to be(false)
  end

  it 'check availability to autorization with agent email in regular booking', retry: 3 do
    auth_from_booking_page('test@test.ua', 'test123')
    # check after autorization will bу new search
    expect(page).to have_selector('.trip_search__progressbar_indicator_done')
    check_lowcosts_and_regular_recommendations
  end
end