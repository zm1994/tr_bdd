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

  search_oneway = DataOneWaySearch.new

  before do
    visit($root_path_avia)
    puts search_oneway.params_flight_dates[:date_departure]
    search_oneway.params_flight_dates[:date_departure] = increase_date_flight(search_oneway.params_flight_dates[:date_departure])
    search_oneway.params_flight_dates[:date_arrival] = increase_date_flight(search_oneway.params_flight_dates[:date_arrival])
  end

  it 'search one way IEV-WAW' do
    search_oneway_trip(search_oneway)
  end

  it 'check one way +-3days', retry: 3 do
    unless($url_recommendation_one_way.empty?)
      visit($url_recommendation_one_way)
      find('[for="avia_search_flexible_date"]').click
      find('.avia_search_form__submit [type="submit"]').click
    else
      search_oneway_with_flexible_dates(search_oneway)
    end
    # find first price in table flexible dates
    expect(page).to have_selector('[data-class="Avia.RecommendationsFilter"]')
    first('.avia_calendar_grid__price_cell[data-x] .avia_calendar_grid__link').click
    #check that after check element from table will start search
    check_lowcosts_and_regular_recommendations
  end

  it 'open one_way booking page' do
    open_booking_page_oneway(search_oneway)
  end

  it 'make one_way booking with 3 passengers', retry: 3 do
    booking_oneway_trip(search_oneway)
  end

  it 'check oneway fare rules' do
    if($url_recommendation_one_way.empty?)
      search_oneway_trip(search_oneway)
    else
      visit($url_recommendation_one_way)
    end

    # find first fare rule end check content
    check_fare_rules
  end

  it 'check avia oneway journey list modal window' do
    if($url_recommendation_one_way.empty?)
      search_oneway_trip(search_oneway)
    else
      visit($url_recommendation_one_way)
    end

    # find first fare rule end check content
    check_avia_journey_modal
  end
end