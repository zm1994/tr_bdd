require 'support/avia_search_helper'

module AviaBooking
  include AviaSearch

  $url_page_booking_one_way_regular = ''
  $url_page_booking_round_regular = ''
  $url_page_booking_complex_regular = ''
  $url_page_booking_one_way_lowcost = ''
  $url_page_booking_round_lowcost = ''
  $url_page_booking_complex_lowcost= ''

  def open_booking_page(url_page_recommendation, type_recommendation = 'regular')
    visit(url_page_recommendation) if url_page_recommendation.length > 0 and page.current_url != url_page_recommendation
    #open booking page from first regular recommendation
    if(type_recommendation == 'regular')
      first('[data-kind="regular"] [data-role="avia_recommendation.select"]').click
    else
      first('[data-kind="lowcost"] [data-role="avia_recommendation.select"]').click
    end
    expect(page).to have_selector('.modal_dialog__preloader')
    expect(page).not_to have_selector('.modal_dialog__preloader')
    # continue_booking_if_price_changed
    continue_booking
    expect(page).to have_selector('.avia_journey__sections_list')
    # return '' if page.has_css?('.notify_message_layout-modal_dialog')
    page.current_url
  end

  def try_open_booking_page_for_regular(url_recommendation, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    booking_page = ''
    5.times do
      if(url_recommendation.length == 0) # if there is no url recommendation first start search
        try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
        url_recommendation = page.current_url
      end
      # try to open booking page 5 times, if there is error message will start new search with increase flight dates
        booking_page = open_booking_page(url_recommendation, 'regular')
        break unless booking_page == ''
        params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
        params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
        try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
        url_recommendation = page.current_url
    end

    booking_page
  end

  def try_open_booking_page_for_lowcost(url_recommendation, type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    booking_page = ''
    5.times do
      if(url_recommendation.length == 0) # if there is no url recommendation first start search
        try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
        url_recommendation = page.current_url
      end
      # try to open booking page 5 times, if there is error message will start new search with increase flight dates
      booking_page = open_booking_page(url_recommendation, 'lowcost')
      break unless booking_page.nil?
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
      try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
      url_recommendation = page.current_url
    end
    if page.has_css?('.notify_message_layout-modal_dialog')
      url_recommendation = ''
      booking_page = ''
    end
    booking_page
  end

  def fill_passenger(block_passengers, data_passengers)
    find("#{block_passengers} .avia_order_journey_item_element_documents_firstname input").set data_passengers[:first_name]
    find("#{block_passengers} .avia_order_journey_item_element_documents_lastname input").set data_passengers[:last_name]
    # block_passengers.find('.avia_order_journey_item_element_documents_birth_date input').set data_passengers[:birthday]
    page.execute_script("$('#{block_passengers} .avia_order_journey_item_element_documents_birth_date input').val('#{data_passengers[:birthday]}')")
    find("#{block_passengers} .avia_order_journey_item_element_documents_passport_number input").set data_passengers[:passport_number]
    # block_passengers.find('.avia_order_journey_item_element_documents_passport_expires_at input').set data_passengers[:passport_expired]
    page.execute_script("$('#{block_passengers} .avia_order_journey_item_element_documents_passport_expires_at input').val('#{data_passengers[:passport_expired]}')")
  end

  def input_data_payer_corporate(payer)
    find('[for="avia_order_payer_attributes_payer_type_corporate"]').click
    find('.avia_order_payer_company_name input').set payer[:juridical_name] unless payer[:juridical_name].nil?
    find('.company_registration_number input').set payer[:registration_number]
    find('avia_order_payer_email input').set payer[:email]
    find('#avia_order_payer_attributes_phone').set payer[:phone]
  end

  def input_data_payer_physical(payer)
    find('[for="avia_order_payer_attributes_payer_type_physical"]').click
    find('.avia_order_payer_full_name input').set payer[:full_name]
    find('.avia_order_payer_email input').set payer[:email]
    find('#avia_order_payer_attributes_phone').set payer[:phone]
  end

  def input_promocode(promo_code)
    find('input#avia_order_use_promocode_discount').set promo_code
  end

  def choose_additional_services
    find('.avia_order_form__selectable_list .avia_order_form__selectable_list_item:nth-of-type(1) label').click
  end

  # this method for offline payment, which are default chosen
  def try_booking_regular(recommendation_url, page_booking_url)
    find('button.order_form__button_role-submit').click
    expect(page).to have_selector('.modal_dialog__preloader')
    continue_booking
    return_from_payment_gateway
  end

  def return_from_payment_gateway
    # return from payment system after making booking on page with created booking
    if page.has_css?('.bill')
      first('.bill_actions_list__action').click
    elsif page.has_css?('.cancel__payment')
      find('.cancel__payment a').click
    end
    expect(page).to have_selector('.avia_order')
  end

  def continue_booking
    # continue booking if there is modal message about changing booking price
    if page.has_css?('.notify_message__action_link_display_as-button')
      find('.notify_message__action_link_display_as-button').click
    end
  end
end