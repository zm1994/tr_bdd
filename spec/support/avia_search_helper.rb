module AviaSearch
  $url_recommendation_one_way = ""
  $url_recommendation_round = ""
  $url_recommendation_complex = ""

  def try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers,
                         with_flexible_dates = false)
    # start 5 tries if search was failed
    5.times do
      start_avia_search(type_avia_search, params_avia_location, params_flight_dates, params_passengers, with_flexible_dates)
      recommendation_list = find('[data-class="Avia.RecommendationsList"]')
      break if recommendation_list.has_selector?('[data-kind="regular"]')
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
    end
  end

  def try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers,
                                      with_flexible_dates = false)
    # start 5 tries if search was failed
    5.times do
      start_avia_search(type_avia_search, params_avia_location, params_flight_dates, params_passengers,
                        with_flexible_dates)

      expect(page).to have_selector('.avia_recommendations__lowcosts_preloader')
      expect(page).not_to have_selector('.avia_recommendations__lowcosts_preloader')

      recommendation_list = find('[data-class="Avia.RecommendationsList"]')
      break if recommendation_list.has_selector?('.avia_recommendation[data-kind="regular"]') and
          recommendation_list.has_selector?('.avia_recommendation[data-kind="lowcost"]')

      # increase date departure and arrival
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
    end
  end

  def start_avia_search(type_avia_search, papams_avia_location, params_flight_dates, params_passengers,
                        with_flexible_dates)
    if(type_avia_search == 'one_way')
      set_params_oneway_trip(papams_avia_location, params_flight_dates)
    elsif(type_avia_search == 'round_trip')
      set_params_round_trip(papams_avia_location, params_flight_dates)
    elsif(type_avia_search == 'complex_trip')
      set_params_complex_trip(papams_avia_location, params_flight_dates)
    end

    choose_passengers(params_passengers)
    find('[for="avia_search_flexible_date"]').click if with_flexible_dates
    find('.avia_search_form__submit [type="submit"]').click
  end


  def set_params_oneway_trip(papams_avia_location, params_flight_dates)
    input_departure_location(papams_avia_location[:departure_avia_city], papams_avia_location[:departure_avia_code])
    input_arrival_location(papams_avia_location[:arrival_avia_city], papams_avia_location[:arrival_avia_code])

    # choose oneway in datepicker and set date in input field
    page.execute_script("$('#avia_search_segments_attributes_0_departure_date').val('#{params_flight_dates[:date_departure]}')")
    find('.avia_search_segments_departure_date').click
    find('.datepicker_switcher__item-oneway').click
  end

  def set_params_round_trip(papams_avia_location, params_flight_dates)
    input_departure_location(papams_avia_location[:departure_avia_city], papams_avia_location[:departure_avia_code])
    input_arrival_location(papams_avia_location[:arrival_avia_city], papams_avia_location[:arrival_avia_code])

    page.execute_script("$('#avia_search_segments_attributes_0_departure_date').val('#{params_flight_dates[:date_departure]}')")
    page.execute_script("$('#avia_search_segments_attributes_0_return_date').val('#{params_flight_dates[:date_arrival]}')")
  end

  def set_params_complex_trip(papams_avia_location, params_flight_dates)
    if page.has_css?('.avia_recommendations__complex_routes_wrapper')
      find('.complex_routes__change_search_button').click
    else
      find('.avia_search_form_footer__complex_trip_link').click
    end
    input_departure_location(papams_avia_location[:departure_avia_city], papams_avia_location[:departure_avia_code])
    input_arrival_location(papams_avia_location[:arrival_avia_city], papams_avia_location[:arrival_avia_code])
    # change departure and arrival location and set locations in second field of search
    input_departure_location(2, papams_avia_location[:arrival_avia_city], papams_avia_location[:arrival_avia_code])
    input_arrival_location(2, papams_avia_location[:departure_avia_city], papams_avia_location[:departure_avia_code])

    # set date first and second trip
    page.execute_script("$('#avia_search_segments_attributes_0_departure_date').val('#{params_flight_dates[:date_departure]}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(2) .avia_search_segments_departure_date input').val('#{params_flight_dates[:date_arrival]}')")
  end

  def input_departure_location(number_field_in_search_form = 1, avia_city, avia_code)
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_from_input').val('#{avia_city}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_from_code__value').text('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_from_code__input').val('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_from_type__input').val('city')")
  end

  def input_arrival_location(number_field_in_search_form = 1, avia_city, avia_code)
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_to_input').val('#{avia_city}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_to_code__value').text('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_to_code__input').val('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .avia_location_to_type__input').val('city')")
  end

  def choose_passengers(params_passengers)
    # open slide
    find('.passengers_with_class__input').click
    # find('#avia_search_adults_count').set params_passengers[:adults]
    # find('#avia_search_children_count').set params_passengers[:children]
    # find('#avia_search_infants_count').set params_passengers[:infants]
    page.execute_script("$('[data-class=\"Avia.AdultsCountInput\"] .passengers_count__input').val(\'#{params_passengers[:adults]}\')")
    page.execute_script("$('[data-class=\"Avia.ChildrenCountInput\"] .passengers_count__input').val(\'#{params_passengers[:children]}\')")
    page.execute_script("$('[data-class=\"Avia.InfantsCountInput\"] .passengers_count__input').val(\'#{params_passengers[:infants]}\')")
    choose_cabin_class(params_passengers[:cabin_class])
    # close slide
    # find('.avia_search_passengers_with_class').click
  end

  def choose_cabin_class(class_type)
    if(class_type == 'economy')
      page.execute_script("$('.cabin_class[value=\"economy\"]').click()")
    else
      page.execute_script("$('.cabin_class[value=\"business\"]').click()")
    end
  end

  def increase_date_flight(flight_date)
    unless flight_date.nil?
      date = Time.parse(flight_date) + 1.day
      date.strftime("%d.%m.%Y")
    end
  end

  def check_lowcosts_and_regular_recommendations
    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
    expect(page).to have_selector('.avia_recommendation[data-kind="lowcost"]')
  end

  def check_aviability_regular_recommendations
    expect(page).to have_selector('.avia_recommendation[data-kind="regular"]')
  end

  def check_fare_rules
    first('[data-modal="Загружаем правила тарифа"]').click
    # get all fare rules in order
    expect(page).to have_selector('.modal_dialog__content')

    all('.direction_layout-modal_dialog').each do |fare_tab|
      fare_tab.click
      fare_rule = find('.avia_terms__content pre')
      # check that text rule isn't empty
      expect(fare_rule.text.length > 0).to be true
    end
  end

  def check_avia_journey_modal
    first('[data-role="avia_recommendation.details"]').click
    expect(page).to have_selector('.avia_journey_layout-modal_dialog')
  end
end