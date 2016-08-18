require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/search_helper'
require 'support/booking_helper'
require 'support/test_data_helper'

describe 'Form search' do
  include AviaSearch
  include AviaBooking

  search = DataOneWaySearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers
  data_passengers = Passengers.new
  data_payer = Payer.new

  before do
    visit($dev_root_path)
    params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
    params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
  end

  it 'search one way IEV-WAW' do
    try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    check_aviability_lowcosts_and_redular
    $url_recommendation_one_way = page.current_url
  end

  it 'check one way +-3days' do
    unless($url_recommendation_one_way.length == 0)
      visit($url_recommendation_one_way)
      find('[for="avia_search_flexible_date"]').click
      find('.avia_search_form__submit [type="submit"]').click
    else
      try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers, true)
    end
    # find first price in table flexible dates
    expect(page).to have_selector('.avia_recommendations__search_form_wrapper')
    first('.avia_calendar_grid__price_cell[data-x] .avia_calendar_grid__link').click
    #check that after check element from table will start search
    expect(page).to have_selector('.avia_recommendations__lowcosts_preloader')
    expect(page).not_to have_selector('.avia_recommendations__lowcosts_preloader')
    check_aviability_lowcosts_and_redular
  end

  it 'open one_way booking page', retry: 3 do
    $url_page_booking_one_way_regular = try_open_booking_page_for_regular($url_recommendation_one_way, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_one_way_regular).not_to be(nil)
  end

  it 'make booking with 3 passengers', js:true do
    $url_page_booking_one_way_regular = try_open_booking_page_for_regular($url_recommendation_one_way, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    first_passenger = find('#document_0')
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = find('#document_1')
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = find('#document_2')
    fill_passenger(third_passenger, data_passengers.params_infant)
    input_data_payer_physical(data_payer)
    try_booking_regular($url_recommendation_one_way, $url_page_booking_one_way_regular)
  end
end