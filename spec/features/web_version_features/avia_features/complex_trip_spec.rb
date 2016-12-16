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

  search_complex = DataComplexSearch.new

  before do
    visit($root_path_avia)
    search_complex.params_flight_dates[:date_departure] = increase_date_flight(search_complex.params_flight_dates[:date_departure])
    search_complex.params_flight_dates[:date_arrival] = increase_date_flight(search_complex.params_flight_dates[:date_arrival])
  end

  it'search complex trip IEV-WAW', retry: 3 do
    search_complex_trip(search_complex)
  end

  it 'open complex booking page for regular', retry: 3 do
    open_booking_page_complex(search_complex)
  end

  it 'make complex booking with 3 passengers', retry: 3 do
    booking_complex_trip(search_complex)
  end

  it 'check complex fare rules ' do
    if($url_recommendation_complex.empty?)
      search_complex_trip(search_complex)
    else
      visit($url_recommendation_complex)
    end

    # find first fare rule end check content
    check_fare_rules
  end

  it 'check complex journey list modal window' do
    if($url_recommendation_complex.empty?)
      search_complex_trip(search_complex)
    else
      visit($url_recommendation_complex)
    end

    # find first fare rule end check content
    check_avia_journey_modal
  end
end