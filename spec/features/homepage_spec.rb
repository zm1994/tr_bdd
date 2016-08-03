require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/search_helper'

describe 'Form search' do
  include AviaSearch

  departure_city = 'Киев'
  departure_avia_code = 'IEV'
  arrival_city = 'Варшава'
  arrival_avia_code = 'WAW'
  # departure_city = 'Гвадар'
  # departure_avia_code = 'GWD'
  # arrival_city = 'Лондон'
  # arrival_avia_code = 'LON'

  before do
    visit('https://tripway.dev')
  end

  it'search one way IEV-WAW' do
    time_departure = Time.now + 2.days
    string_format_date = time_departure.strftime("%d.%m.%Y")
    type_avia_search =  'one_way'

    params_avia_location = {departure_avia_city: departure_city,
                            departure_avia_code: departure_avia_code,
                            arrival_avia_city: arrival_city,
                            arrival_avia_code: arrival_avia_code}

    params_flight_dates = {date_departure: string_format_date}

    params_passengers = {adults: '1', children: '1', infants: '1', cabin_class: 'economy'}

    try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)

    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
    expect(page).to have_selector('.avia_recommendation[data-kind="lowcost"]')
    $url_recommendation_one_way = page.current_url
  end

  it'search round IEV-WAW' do
    time_departure = Time.now + 2.days
    string_format_date_dep = time_departure.strftime("%d.%m.%Y")
    time_arrive = time_departure + 10.days
    string_format_date_arr = time_arrive.strftime("%d.%m.%Y")
    type_avia_search =  'round_trip'

    params_avia_location = {departure_avia_city: departure_city,
                            departure_avia_code: departure_avia_code,
                            arrival_avia_city: arrival_city,
                            arrival_avia_code: arrival_avia_code}

    params_flight_dates = {date_departure: string_format_date_dep,
                           date_arrival: string_format_date_arr}

    params_passengers = {adults: '1', children: '1', infants: '1', cabin_class: 'economy'}

    try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)

    puts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
    expect(page).to have_selector('.avia_recommendation[data-kind="lowcost"]')
    $url_recommendation_round = page.current_url
  end

  it'search complex trip IEV-WAW' do
    time_departure = Time.now + 2.days
    string_format_date_dep = time_departure.strftime("%d.%m.%Y")
    time_arrive = time_departure + 10.days
    string_format_date_arr = time_arrive.strftime("%d.%m.%Y")
    type_avia_search =  'complex_trip'

    params_avia_location = {departure_avia_city: departure_city,
                            departure_avia_code: departure_avia_code,
                            arrival_avia_city: arrival_city,
                            arrival_avia_code: arrival_avia_code}

    params_flight_dates = {date_departure: string_format_date_dep,
                           date_arrival: string_format_date_arr}

    params_passengers = {adults: '1', children: '1', infants: '1', cabin_class: 'economy'}

    try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)

    puts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
    $url_recommendation_complex = page.current_url
  end
end



