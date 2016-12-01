require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/mobile_avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/mobile_avia_booking_helper'
require 'support/mobile_booking_service_helper'

describe 'Mobile search/booking oneway' do
  include MobileAviaSearch
  include MobileAviaBooking
  include MobileBookingService

  search_oneway = DataOneWaySearch.new

  before do
    visit($root_path_mobile_avia)
    search_oneway.params_flight_dates[:date_departure] = increase_date_flight(search_oneway.params_flight_dates[:date_departure])
    search_oneway.params_flight_dates[:date_arrival] = increase_date_flight(search_oneway.params_flight_dates[:date_arrival])
  end

  it 'search one way IEV-WAW' do
    search_mobile_oneway_trip(search_oneway)
  end

  it 'open one_way booking page', retry: 3 do
    open_mobile_booking_page_oneway(search_oneway)
  end

  it 'make mobile one_way booking with 3 passengers', retry: 3  do
    booking_mobile_oneway_trip(search_oneway)
  end
end