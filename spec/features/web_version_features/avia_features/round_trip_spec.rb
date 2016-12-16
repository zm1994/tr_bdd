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

  search_round = DataRoundSearch.new

  before do
    visit($root_path_avia)
    search_round.params_flight_dates[:date_departure] = increase_date_flight(search_round.params_flight_dates[:date_departure])
    search_round.params_flight_dates[:date_arrival] = increase_date_flight(search_round.params_flight_dates[:date_arrival])
  end

  it'search round_trip IEV-WAW' do
    search_round_trip(search_round)
  end

  it'check round_trip +-3days from page recommendation', retry: 3 do
    unless($url_recommendation_round.empty?)
      visit($url_recommendation_round)
      find('[for="avia_search_flexible_date"]').click
      find('.avia_search_form__submit [type="submit"]').click
    else
      search_round_with_flexible_dates(search_round)
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
    open_booking_page_round(search_round)
  end

  it 'make round booking with 3 passengers', retry: 3  do
    booking_round_trip(search_round)
  end

  it 'check round fare rules ' do
    if($url_recommendation_round.empty?)
      search_round_trip(search_round)
    else
      visit($url_recommendation_round)
    end
    # find first fare rule end check content
    check_fare_rules
  end

  it 'check round journey list modal window' do
    if($url_recommendation_round.empty?)
      search_round_trip(search_round)
    else
      visit($url_recommendation_round)
    end

    # find first fare rule end check content
    check_avia_journey_modal
  end
end
