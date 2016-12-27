require 'support/avia_booking_helper'
require 'support/avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/avia_booking_service_helper'

module AdminOrderService
  include AviaSearch
  include AviaBooking
  include AviaBookingService

  def open_round_trip_order
    unless($round_trip_booking_regular.empty?)
      find('a', text: $round_trip_booking_regular).click
      expect(page).to have_content($round_trip_booking_regular)
    else
      # search_round = DataRoundSearch.new
      # booking_round_trip(search_round)
      search_one = DataOneWaySearch.new
      booking_oneway_trip(search_one)
    end
  end
end