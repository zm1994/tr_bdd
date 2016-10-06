require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'

describe 'Form search' do
  include AviaSearch
  include AviaBooking
  # include TestData

  search = DataComplexSearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers
  data_passengers = Passengers.new
  payer = Payer.new

  before do
    visit($root_path_avia)
    params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
    params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
  end

  it'search complex trip IEV-WAW', retry: 3 do
    try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    puts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
    $url_recommendation_complex = page.current_url
  end

  it 'open complex booking page for regular', retry: 3 do
    $url_page_booking_complex_regular = try_open_booking_page_for_regular($url_recommendation_complex, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_complex_regular).not_to be(nil)
  end

  it 'make booking with 3 passengers', retry: 3 do
    $url_page_booking_complex_regular = try_open_booking_page_for_regular($url_recommendation_complex, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)
    # pry.binding
    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_complex, $url_page_booking_complex_regular)
  end
end