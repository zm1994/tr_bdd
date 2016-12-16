require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/user_profile_helper'

module MobileBookingService
  include MobileAviaSearch
  include MobileAviaBooking

  $mobile_round_trip_booking_regular = ""
  $mobile_oneway_trip_booking_regular = ""
  $mobile_complex_trip_booking_regular = ""

  def booking_mobile_round_trip(search_round)
    # increase date departure and arrival
    search_round.params_flight_dates[:date_departure] = increase_date_flight(search_round.params_flight_dates[:date_departure])
    search_round.params_flight_dates[:date_arrival] = increase_date_flight(search_round.params_flight_dates[:date_arrival])

    $url_mobile_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_mobile_recommendation_round,
                                                                               search_round.type_avia_search,
                                                                               search_round.params_avia_location,
                                                                               search_round.params_flight_dates,
                                                                               search_round.params_passengers)
    data_passengers = Passengers.new
    payer = Payer.new

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
    try_booking_regular($url_mobile_recommendation_round, $url_mobile_page_booking_round_regular)

    $mobile_round_trip_booking_regular = find('.order__code_link').text
  end

  def search_mobile_round_trip(search_round)
    try_search_regular_and_lowcosts_mobile(search_round.type_avia_search, search_round.params_avia_location, search_round.params_flight_dates,
                                    search_round.params_passengers)
    check_aviability_regular_recommendations
    $url_mobile_recommendation_round = page.current_url
  end

  def open_mobile_booking_page_round(search_round)
    $url_mobile_page_booking_round_regular = try_open_booking_page_for_regular_mobile($url_mobile_recommendation_round,
                                                                               search_round.type_avia_search,
                                                                               search_round.params_avia_location,
                                                                               search_round.params_flight_dates,
                                                                               search_round.params_passengers)
  end

  def booking_mobile_oneway_trip(search_oneway)
    # increase date departure and arrival
    search_oneway.params_flight_dates[:date_departure] = increase_date_flight(search_oneway.params_flight_dates[:date_departure])
    search_oneway.params_flight_dates[:date_arrival] = increase_date_flight(search_oneway.params_flight_dates[:date_arrival])

    $url_mobile_page_booking_one_way_regular = try_open_booking_page_for_regular_mobile($url_mobile_recommendation_one_way,
                                                                                 search_oneway.type_avia_search,
                                                                                 search_oneway.params_avia_location,
                                                                                 search_oneway.params_flight_dates,
                                                                                 search_oneway.params_passengers)
    data_passengers = Passengers.new
    payer = Payer.new

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
    try_booking_regular($url_mobile_recommendation_one_way, $url_mobile_page_booking_one_way_regular)
  end

  def search_mobile_oneway_trip(search_oneway)
    try_search_regular_and_lowcosts_mobile(search_oneway.type_avia_search, search_oneway.params_avia_location, search_oneway.params_flight_dates,
                                           search_oneway.params_passengers)
    check_aviability_regular_recommendations
    $url_mobile_recommendation_one_way = page.current_url
  end

  def open_mobile_booking_page_oneway(search_oneway)
    $url_mobile_page_booking_one_way_regular = try_open_booking_page_for_regular_mobile($url_mobile_recommendation_one_way,
                                                                                 search_oneway.type_avia_search,
                                                                                 search_oneway.params_avia_location,
                                                                                 search_oneway.params_flight_dates,
                                                                                 search_oneway.params_passengers)
  end
end
