require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/avia_booking_service_helper'

describe 'Form search' do
  include AviaSearch
  include AviaBooking
  include AviaBookingService
  # include TestData

  # search = DataComplexSearch.new
  # type_avia_search = search.type_avia_search
  # params_avia_location = search.params_avia_location
  # params_flight_dates = search.params_flight_dates
  # params_passengers = search.params_passengers
  # data_passengers = Passengers.new
  # payer = Payer.new

  before do
    visit($root_path_avia)
  end

  it'search complex trip IEV-WAW', retry: 3 do
    search_complex_trip
    $url_recommendation_complex = page.current_url
  end

  it 'open complex booking page for regular', retry: 3 do
    open_booking_page_complex
    expect($url_page_booking_complex_regular).not_to be(nil)
  end

  it 'make complex booking with 3 passengers', retry: 3 do
    booking_complex_trip
  end

  it 'check complex fare rules ' do
    if($url_recommendation_complex.empty?)
      search_complex_trip
      $url_recommendation_complex = page.current_url
    else
      visit($url_recommendation_complex)
    end

    # find first fare rule end check content
    check_fare_rules
  end

  it 'check complex journey list modal window' do
    if($url_recommendation_complex.empty?)
      search_complex_trip
      $url_recommendation_complex = page.current_url
    else
      visit($url_recommendation_complex)
    end

    # find first fare rule end check content
    check_avia_journey_modal
  end
end