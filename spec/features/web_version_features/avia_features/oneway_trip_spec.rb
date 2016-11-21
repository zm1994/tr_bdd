require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'

describe 'Form search' do
  include AviaSearch
  include AviaBooking

  search = DataOneWaySearch.new
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

  it 'search one way IEV-WAW' do
    try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    check_lowcosts_and_regular_recommendations
    $url_recommendation_one_way = page.current_url
  end

  it 'check one way +-3days', retry: 3 do
    unless($url_recommendation_one_way.length == 0)
      visit($url_recommendation_one_way)
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

  it 'open one_way booking page' do
    $url_page_booking_one_way_regular = try_open_booking_page_for_regular($url_recommendation_one_way, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_one_way_regular).not_to be(nil)
  end

  it 'make one_way booking with 3 passengers', retry: 3  do
    $url_page_booking_one_way_regular = try_open_booking_page_for_regular($url_recommendation_one_way, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)
    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_one_way, $url_page_booking_one_way_regular)
  end

  it 'check oneway fare rules ' do
    if($url_recommendation_one_way.length == 0)
      $url_recommendation_one_way = try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    else
      visit($url_recommendation_one_way)
    end

    # find first fare rule end check content
    check_fare_rules
  end

  it 'check avia oneway journey list modal windo' do
    if($url_recommendation_one_way.length == 0)
      $url_recommendation_one_way = try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    else
      visit($url_recommendation_one_way)
    end

    # find first fare rule end check content
    check_avia_journey_modal
  end
end