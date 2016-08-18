require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/search_helper'
require 'support/booking_helper'
require 'support/test_data_helper'

describe 'Form search' do
  include AviaSearch
  include AviaBooking
  include TestData

  search = DataRoundSearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers

  before do
    visit($dev_root_path)
  end

  it'search round_trip IEV-WAW' do
    try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    puts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    check_aviability_lowcosts_and_redular
    $url_recommendation_round = page.current_url
  end

  it'check round_trip +-3days from page recommendation' do
    unless($url_recommendation_round.length == 0)
      visit($url_recommendation_round)
      find('[for="avia_search_flexible_date"]').click
      find('.avia_search_form__submit [type="submit"]').click
    else
      try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers, true)
    end
    # find first price in table flexible dates
    expect(page).to have_selector('.avia_recommendations__search_form_wrapper')
    first('.avia_calendar_grid__price_cell[data-x] .avia_calendar_grid__link').click
    #check that after check element from table will start search
    expect(page).to have_selector('.avia_recommendations__lowcosts_preloader')
    expect(page).not_to have_selector('.avia_recommendations__lowcosts_preloader')
    check_aviability_lowcosts_and_redular
  end

  it 'open round booking page', retry: 3 do
    $url_page_booking_round_regular = try_open_booking_page_for_regular($url_recommendation_round, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_round_regular).not_to be(nil)
  end
end
