require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/mobile_avia_search_helper'
require 'support/avia_test_data_helper'
require 'support/mobile_avia_booking_helper'

describe 'Mobile search/booking oneway' do
  include MobileAviaSearch
  include MobileAviaBooking

  search = DataOneWaySearch.new
  type_avia_search = search.type_avia_search
  params_avia_location = search.params_avia_location
  params_flight_dates = search.params_flight_dates
  params_passengers = search.params_passengers
  data_passengers = Passengers.new
  payer = Payer.new

  before do
    visit($root_path_mobile_avia)
    params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
    params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
  end

  it 'search one way IEV-WAW' do
    try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    check_aviability_regular_recommendations
    $url_recommendation_one_way = page.current_url
  end

  it 'open one_way booking page', retry: 3 do
    $url_page_booking_one_way_regular = try_open_booking_page_for_regular_mobile($url_recommendation_one_way, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect($url_page_booking_one_way_regular).not_to be(nil)
  end

  it 'make mobile one_way booking with 3 passengers', retry: 3  do
    $url_page_booking_one_way_regular = try_open_booking_page_for_regular_mobile($url_recommendation_one_way, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    first_passenger = '#document_0'
    fill_passenger(first_passenger, data_passengers.params_adult)
    choose_passenger_citizenship(first_passenger, 'UKR')
    second_passenger = '#document_1'
    fill_passenger(second_passenger, data_passengers.params_child)
    choose_passenger_citizenship(second_passenger, 'UKR')
    third_passenger = '#document_2'
    fill_passenger(third_passenger, data_passengers.params_infant)
    choose_passenger_citizenship(third_passenger, 'UKR')
    input_data_payer_physical(payer.params_payer)
    try_booking_regular($url_recommendation_one_way, $url_page_booking_one_way_regular)
  end

  # it 'count all recommendations', js: true do
  #   # pry.binding
  #   unless($url_recommendation_one_way_mobile.length == 0)
  #     visit($url_recommendation_one_way)
  #   else
  #    try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
  #   end
  #
  #   counter_variants_mobile = all('.avia_recommendation').count
  #   $url_recommendation_one_way_mobile = page.current_url
  #       # replace /?mobile=1 on 0
  #   root_path = $root_path_mobile_avia.sub '1', '0'
  #   # reset mobile mode into web
  #   visit(root_path)
  #   # pry.binding
  #   visit($url_recommendation_one_way_mobile)
  #   expect(page).to have_selector('[data-class="Avia.RecommendationsList"]')
  #   counter_variants_web = 0
  #   count_sections_oneway = 0
  #
  #   # pry.binding
  #   all('.avia_recommendation').each do |recommendation|
  #     count_sections_oneway += recommendation.all('[data-section-index="0"] .section__variant').count
  #     counter_variants_web += count_sections_oneway
  #   end
  #
  #   expect(counter_variants_mobile == counter_variants_web).to be true
  #   # puts counter_variants
  # end
end