require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/mobile_avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/mobile_avia_booking_helper'

describe 'Mobile search/booking round' do
  include MobileAviaSearch
  include MobileAviaBooking


  search = DataRoundSearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers
  data_passengers = Passengers.new
  payer = Payer.new

  before do
    visit($root_path_mobile_avia)
    params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
    params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
  end

  it 'search mobile round trip IEV-WAW' do
    try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    check_aviability_regular_recommendations
    $url_recommendation_round = page.current_url
  end

  it 'open mobile round booking page', retry: 3 do
    $url_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_one_way_regular).not_to be(nil)
  end

  it 'make mobile booking round with 3 passengers', retry: 3 do
    $url_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    choose_passenger_citizenship(first_passenger, 'UKR')
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    choose_passenger_citizenship(second_passenger, 'UKR')
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)
    choose_passenger_citizenship(third_passenger, 'UKR')
    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_round, $url_page_booking_round_regular)
  end
end