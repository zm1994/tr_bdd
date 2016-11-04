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

  search = DataRoundSearch.new
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

  it'search round_trip IEV-WAW' do
    try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    puts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    check_lowcosts_and_regular_recommendations
    $url_recommendation_round = page.current_url
  end

  it'check round_trip +-3days from page recommendation', retry: 3 do
    unless($url_recommendation_round.length == 0)
      visit($url_recommendation_round)
      find('[for="avia_search_flexible_date"]').click
      find('.avia_search_form__submit [type="submit"]').click
    else
      try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers, true)
    end
    # find first price in table flexible dates
    expect(page).to have_selector('[data-class="Avia.RecommendationsFilter"]')
    first('.avia_calendar_grid__price_cell[data-x] .avia_calendar_grid__link').click
    #check that after check element from table will start search
    # expect(page).to have_selector('.avia_recommendations__lowcosts_preloader')
    # expect(page).not_to have_selector('.avia_recommendations__lowcosts_preloader')
    check_lowcosts_and_regular_recommendations
  end

  it 'open round booking page', retry: 3 do
    $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_round_regular).not_to be(nil)
  end

  it 'make round booking with 3 passengers', retry: 3  do
    $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)
    # pry.binding
    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_round, $url_page_booking_round_regular)
  end

  it 'check round fare rules ' do
    if($url_recommendation_complex.length == 0)
      $url_recommendation_complex = try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    else
      visit($url_recommendation_complex)
    end

    # find first fare rule end check content
    first('.avia_recommendation__link').click
    check_fare_rules
  end
end
