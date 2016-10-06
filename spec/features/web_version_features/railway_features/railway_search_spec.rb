require 'rails_helper'
require 'support/firefox_driver'
require 'support/railway_search_helper'
require 'support/railway_test_data_helper'
require 'support/railway_booking_helper'
require 'support/auth_helper'

describe 'Railway search' do
  include RailWaySearch
  include RailwayBooking
  include AuthHelper

  search = DataRailwaySearch.new
  params_departure_location = search.params_departure_location
  params_arrival_location = search.params_arrival_location
  popular_directions = search.array_popular_directions
  date = search.date_railway_departure
  passenger_adult = Passenger.new
  passenger_student = Passenger.new
  passenger_student.set_as_student('Вадим', 'Чернов', 'student', 'АР11006765')

  payer = Payer.new


  before do
    visit($root_path_railway)
    date = increase_date_departure(date)
  end

  it 'searches by popular cities Kiev-Kharkov', retry: 3 do
    $url_avia_recommendation = try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
  end

  it'show stopovers by journey', retry: 3 do
    open_page_recommendation(params_departure_location[:city], params_arrival_location[:city], date)
    # pry.binding
    first('.train_stamp__number').click
    expect(page).to have_selector('.train_stopovers__table_layout-modal_dialog')
  end

  it 'checking modal window by input agent email', retry: 3 do
    open_page_recommendation(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('')
    input_passenger_info(passenger_adult.params_passenger)
    payer.params_payer[:email] = 'test@test.ua'
    input_payer_info(payer.params_payer)
    # expect to be shown modal window with notificate that it is agent email
    expect(page).to have_selector('.notify_message_layout-modal_dialog')
    # authorize with agent email
    find('.notify_message__action_link[href="/profile/login"]').click
    user_mail = 'test@test.ua'
    user_password = 'test123'
    auth_login(user_mail, user_password)
    expect(page).to have_selector('.trip_search__progressbar_indicator_done')
  end

  it 'check unavailability making reserve(17UAH) today' do
    date = get_current_date
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    passenger_input_block = open_passenger_block_input('')
    expect(passenger_input_block).not_to have_selector('.railway_preorder_passengers_ticketing_action ul li:nth-of-type(2)')
  end

  (popular_directions + popular_directions.map(&:reverse)).each do |direction|
    departure_station, arrival_station = direction
    it "check all wagons in page recommendation with (#{departure_station} - #{arrival_station})", retry: 3 do
      try_railway_search(departure_station, arrival_station, date)
      check_all_wagons_on_page_recommendation
      # ['Киев', 'Харьков'], ['Киев', 'Одесса'], ['Киев', 'Львов'], ['Львов', 'Харьков'], ['Харьков', 'Одесса']
    end
  end
end