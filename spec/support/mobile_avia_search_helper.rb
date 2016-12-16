require 'support/avia_search_helper'

module MobileAviaSearch
  include AviaSearch

  $url_mobile_recommendation_one_way = ""
  $url_mobile_recommendation_round = ""

  def try_search_regular_and_lowcosts_mobile(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    # start 5 tries if search was failed
    5.times do
      start_mobile_avia_search(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
      # expect(page).to have_selector('.avia_recommendations__lowcosts_preloader')
      # expect(page).not_to have_selector('.avia_recommendations__lowcosts_preloader')
      recommendation_list = find('[data-class="Avia.RecommendationsList"]')
      # изменить когда будет сверстана моб версия стр реком
      break if recommendation_list.has_selector?('.avia_recommendation[data-kind="regular"]')
      # break if recommendation_list.has_selector?('.avia_recommendation[data-kind="regular"]') and recommendation_list.has_selector?('.avia_recommendation[data-kind="lowcost"]')
      find('.header__back_link').click
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
    end
  end

  def start_mobile_avia_search(type_avia_search, papams_avia_location, params_flight_dates, params_passengers)

    if(type_avia_search == 'one_way')
      set_params_oneway_trip(papams_avia_location, params_flight_dates)
      # go back from datepicker modal window
      close_modal_window
      expect(page).to have_selector('.avia_search_form__theme-mobile_homepage')
    elsif(type_avia_search == 'round_trip')
      set_params_round_trip(papams_avia_location, params_flight_dates)
    end
    # pry.binding
    choose_passengers(params_passengers)
    # close modal passengers window by click submit button
    find('.passengers_with_class__submit_button').click
    # expect(page).to have_selector('.avia_search_form__theme-mobile_homepage')
    find('.avia_search_form__submit [type="submit"]').click
  end

  def close_modal_window
    find('.mobile_page__header_close_btn').click
  end

  def check_mobile_fare_rules
    first('.section__fare_rules_link').click
    # get all fare rules in order
    expect(page).to have_selector('.modal_dialog__content')

    all('.direction_layout-modal_dialog').each do |fare_tab|
      fare_tab.click
      fare_rule = find('.avia_terms__content pre')
      # check that text rule isn't empty
      expect(fare_rule.text.length > 0).to be true
    end
  end
end