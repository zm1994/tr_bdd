require 'rails_helper'
require 'support/firefox_driver'
require 'support/railway_search_helper'
require 'support/railway_test_data_helper'
require 'support/railway_booking_helper'
require 'support/auth_helper'

describe 'Railway booking' do
  include RailWaySearch
  include RailwayBooking
  include AuthHelper

  search = DataRailwaySearch.new
  params_departure_location = search.params_departure_location
  params_arrival_location = search.params_arrival_location
  date = search.date_railway_departure
  passenger_adult = Passenger.new
  passenger_student = Passenger.new
  passenger_student.set_as_student('Вадим', 'Чернов', 'student', 'АР11006765')
  passenger_child = Passenger.new

  payer = Payer.new


  before do
    visit($root_path_railway)
    date = increase_date_departure(date)
  end

  it' make reserve by adult ', retry: 3 do
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('')
    input_passenger_info(passenger_adult.params_passenger)
    input_payer_info(payer.params_payer)
    open_preorder_page
    try_booking
  end

  it'makes reserve by student', retry: 3 do
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('Плацкарт')
    input_passenger_info(passenger_student.params_passenger)
    input_payer_info(payer.params_payer)
    # в js: true могут валиться тесты из-за того что не видит кнопку Купить
    open_preorder_page
    try_booking
  end

  it'makes reserve by child', retry: 3  do
    passenger_child.set_as_child('Иван','Иванов', 'child', '13')
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('')
    input_passenger_info(passenger_child.params_passenger)
    input_payer_info(payer.params_payer)
    # в js: true могут валиться тесты из-за того что не видит кнопку Купить
    open_preorder_page
    try_booking
  end

  it'makes booking', retry: 3 do
    # дата увеличивается посколько резервирование места доступно не более чем 24 часа
    date = increase_date_departure(date)
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('')
    find('.railway_preorder_passengers_ticketing_action ul li:nth-of-type(2)').click
    input_passenger_info(passenger_adult.params_passenger)
    input_payer_info(payer.params_payer)
    # в js: true могут валиться тесты из-за того что не видит кнопку Купить
    open_preorder_page
    try_booking
  end

  it'makes reserve with tea', retry: 3 do
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('Плацкарт')
    input_passenger_info(passenger_adult.params_passenger)
    find('.railway_preorder_passengers_tea').click
    input_payer_info(payer.params_payer)
    open_preorder_page
    expect(page).to have_selector('.additional_service__label', text: 'Чай')
    try_booking
  end

  it'makes reserve with equipment', retry: 3 do
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('')

    input_passenger_info(passenger_adult.params_passenger)
    find('.railway_preorder_passengers_baggage').click
    find('.railway_preorder_passengers_equipment').click
    input_payer_info(payer.params_payer)
    open_preorder_page
    expect(page).to have_selector('.additional_service__label', text: 'Аппаратура')
    try_booking
  end

  it'makes reserve with excess', retry: 3 do
    try_railway_search(params_departure_location[:city], params_arrival_location[:city], date)
    open_passenger_block_input('')
    input_passenger_info(passenger_adult.params_passenger)
    find('.railway_preorder_passengers_baggage').click
    find('.railway_preorder_passengers_excess').click
    input_payer_info(payer.params_payer)
    open_preorder_page
    expect(page).to have_selector('.additional_service__label', text: 'Избыток')
    try_booking
  end
end