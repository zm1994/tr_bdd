require 'support/mobile_avia_search_helper'
require 'support/avia_booking_helper'

module MobileAviaBooking
  include AviaBooking
  include MobileAviaSearch

  $url_mobile_page_booking_one_way_regular = ''
  $url_mobile_page_booking_round_regular = ''
  $url_mobile_page_booking_complex_regular = ''
  $url_mobile_page_booking_one_way_lowcost = ''
  $url_mobile_page_booking_round_lowcost = ''
  $url_mobile_page_booking_complex_lowcost= ''

  def try_open_booking_page_for_regular_mobile(url_recommendation, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    booking_page = ''
    5.times do
      if(url_recommendation.empty?) # if there is no url recommendation first start search
        try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
        url_recommendation = page.current_url
      end
      # try to open booking page 5 times, if there is error message will start new search with increase flight dates
      booking_page = open_booking_page_mobile(url_recommendation, 'regular')
      break unless booking_page == ''
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
      try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
      url_recommendation = page.current_url
    end
    # if page.has_css?('.notify_message_layout-modal_dialog')
    #   url_recommendation = ''
    #   booking_page = ''
    # end
    booking_page
  end

  def try_open_booking_page_for_lowcost_mobile(url_recommendation, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    booking_page = ''
    5.times do
      if(url_recommendation.empty?) # if there is no url recommendation first start search
        try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
        url_recommendation = page.current_url
      end
      # try to open booking page 5 times, if there is error message will start new search with increase flight dates
      booking_page = open_booking_page_mobile(url_recommendation, 'lowcost')
      break unless booking_page.nil?
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
      try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
      url_recommendation = page.current_url
    end
    if page.has_css?('.notify_message_layout-modal_dialog')
      url_recommendation = ''
      booking_page = ''
    end
    booking_page
  end

  def open_booking_page_mobile(url_page_recommendation, type_recommendation = 'regular')
    visit(url_page_recommendation) unless url_page_recommendation.empty? and page.current_url != url_page_recommendation

    #open booking page from first regular recommendation
    if(type_recommendation == 'regular')
      first('[data-kind="regular"][data-role="avia_recommendation.select"]').click
    else
      first('[data-kind="lowcost"][data-role="avia_recommendation.select"]').click
    end
    expect(page).to have_selector('.modal_dialog__preloader')
    expect(page).not_to have_selector('.modal_dialog__preloader')
    # continue booking if price has been changed

    continue_booking
    # continue_booking_if_price_changed
    expect(page).to have_selector('.avia_journey__sections_list')
    # return '' if page.has_css?('.notify_message_layout-modal_dialog')
    page.current_url
  end

  def choose_passenger_citizenship(passenger_block, citizenship_code)
    find("#{passenger_block} .mobile_select_citizenship__visible_input").click
    find("[data-value=\"#{citizenship_code}\"]").click
  end
end