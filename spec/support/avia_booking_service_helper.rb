require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/user_profile_helper'

module AviaBookingService
  include AuthHelper
  include ProfileAviaBookings
  include AviaSearch
  include AviaBooking

  $round_trip_booking_regular = ""
  $oneway_trip_booking_regular = ""
  $complex_trip_booking_regular = ""


  def booking_round_trip
    search_round = DataRoundSearch.new
    # increase date departure and arrival
    search_round.params_flight_dates[:date_departure] = increase_date_flight(search_round.params_flight_dates[:date_departure])
    search_round.params_flight_dates[:date_arrival] = increase_date_flight(search_round.params_flight_dates[:date_arrival])

    $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round,
                                                                        search_round.type_avia_search,
                                                                        search_round.params_avia_location,
                                                                        search_round.params_flight_dates,
                                                                        search_round.params_passengers)
    data_passengers = Passengers.new
    payer = Payer.new

    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)
    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_round, $url_page_booking_round_regular)

    $round_trip_booking_regular = find('.order__code_link').text
  end

  def booking_oneway_trip
    search_oneway = DataOneWaySearch.new
    # increase date departure and arrival
    search_oneway.params_flight_dates[:date_departure] = increase_date_flight(search_oneway.params_flight_dates[:date_departure])
    search_oneway.params_flight_dates[:date_arrival] = increase_date_flight(search_oneway.params_flight_dates[:date_arrival])

    $url_page_booking_one_way_regular = try_open_booking_page_for_regular($url_recommendation_one_way,
                                                                          search_oneway.type_avia_search,
                                                                          search_oneway.params_avia_location,
                                                                          search_oneway.params_flight_dates,
                                                                          search_oneway.params_passengers)
    data_passengers = Passengers.new
    payer = Payer.new

    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)

    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_one_way, $url_page_booking_one_way_regular)

    $oneway_trip_booking_regular = find('.order__code_link').text
  end

  def booking_complex_trip
    search_complex = DataComplexSearch.new
    # increase date departure and arrival
    search_complex.params_flight_dates[:date_departure] = increase_date_flight(search_complex.params_flight_dates[:date_departure])
    search_complex.params_flight_dates[:date_arrival] = increase_date_flight(search_complex.params_flight_dates[:date_arrival])

    $url_page_booking_complex_regular = try_open_booking_page_for_regular($url_recommendation_complex,
                                                                          search_complex.type_avia_search,
                                                                          search_complex.params_avia_location,
                                                                          search_complex.params_flight_dates,
                                                                          search_complex.params_passengers)
    data_passengers = Passengers.new
    payer = Payer.new

    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)

    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_complex, $url_page_booking_complex_regular)

    $complex_trip_booking_regular = find('.order__code_link').text
  end

  def search_complex_trip
    search_complex = DataComplexSearch.new
    try_search_regular(search_complex.type_avia_search, search_complex.params_avia_location, search_complex.params_flight_dates,
                       search_complex.params_passengers)
    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
  end

  def open_booking_page_complex
    search_complex = DataComplexSearch.new
    $url_page_booking_complex_regular = try_open_booking_page_for_regular($url_recommendation_complex,
                                                                          search_complex.type_avia_search,
                                                                          search_complex.params_avia_location,
                                                                          search_complex.params_flight_dates,
                                                                          search_complex.params_passengers)
  end
end