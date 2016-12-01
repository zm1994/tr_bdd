require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/mobile_avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/mobile_avia_booking_helper'
require 'support/mobile_booking_service_helper'

describe 'Mobile search/booking round' do
  include MobileAviaSearch
  include MobileAviaBooking
  include MobileBookingService

  search_round = DataRoundSearch.new

  before do
    visit($root_path_mobile_avia)
    search_round.params_flight_dates[:date_departure] = increase_date_flight(search_round.params_flight_dates[:date_departure])
    search_round.params_flight_dates[:date_arrival] = increase_date_flight(search_round.params_flight_dates[:date_arrival])
  end

  it 'search mobile round trip IEV-WAW' do
    search_mobile_round_trip(search_round)
  end

  it 'open mobile round booking page', retry: 3 do
    open_mobile_booking_page_round(search_round)
  end

  it 'make mobile booking round with 3 passengers', retry: 3 do
    booking_mobile_round_trip(search_round)
  end
end