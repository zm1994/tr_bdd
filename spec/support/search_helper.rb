module AviaSearch
  $url_recommendation_one_way = ""
  $url_recommendation_round = ""
  $url_recommendation_complex = ""

  def choose_avia_search(type_avia_search, papams_avia_location, params_flight_dates, params_passangers)
    if(type_avia_search == 'one_way')
      search_one_way_trip(papams_avia_location, params_flight_dates)
    elsif(type_avia_search == 'round_trip')
      search_round_trip(papams_avia_location, params_flight_dates)
    elsif(type_avia_search == 'complex_trip')
      search_complex_trip(papams_avia_location, params_flight_dates)
    end

    choose_passengers(params_passangers)
    find('.avia_search_form__submit [type="submit"]').click
  end

  def search_one_way_trip(papams_avia_location, params_flight_dates)
    input_departure_location(papams_avia_location[:departure_avia_city], papams_avia_location[:departure_avia_code])
    input_arrival_location(papams_avia_location[:arrival_avia_city], papams_avia_location[:arrival_avia_code])

    # choose oneway in datepicker and set date in input field
    find('.avia_search_segments_departure_date').click
    find('.datepicker_switcher__item-oneway').click
    page.execute_script("$('#avia_search_segments_attributes_0_departure_date').val('#{params_flight_dates[:date_departure]}')")
  end

  def search_round_trip(papams_avia_location, params_flight_dates)
    input_departure_location(papams_avia_location[:departure_avia_city], papams_avia_location[:departure_avia_code])
    input_arrival_location(papams_avia_location[:arrival_avia_city], papams_avia_location[:arrival_avia_code])

    page.execute_script("$('#avia_search_segments_attributes_0_departure_date').val('#{params_flight_dates[:date_departure]}')")
    page.execute_script("$('#avia_search_segments_attributes_0_return_date').val('#{params_flight_dates[:date_arrival]}')")
  end

  def search_complex_trip(papams_avia_location, params_flight_dates)
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
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .departure input:first-child()').val('#{avia_city}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .departure .avia_location_from_code__value').text('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .departure .avia_location_from_code__input').val('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .departure .avia_location_from_type__input').val('city')")
  end

  def input_arrival_location(number_field_in_search_form = 1, avia_city, avia_code)
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .arrival input:first-child()').val('#{avia_city}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .arrival .avia_location_to_code__value').text('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .arrival .avia_location_to_code__input').val('#{avia_code}')")
    page.execute_script("$('.avia_search_form__segments .fields:nth-of-type(#{number_field_in_search_form}) .arrival .avia_location_to_type__input').val('city')")
  end

  def choose_passengers(params_passengers)
    find('.avia_search_passengers_with_class').click
    find('#avia_search_adults_count').set params_passengers[:adults]
    find('#avia_search_children_count').set params_passengers[:children]
    find('#avia_search_infants_count').set params_passengers[:infants]

    choose_cabin_class(params_passengers[:cabin_class])
  end

  def choose_cabin_class(class_type)
    if(class_type == 'economy')
      find('label[for="avia_search_cabin_class_economy"]').click
    else
      find('label[for="avia_search_cabin_class_business"]').click
    end
  end

  def increase_date_flight(flight_date)
    date = Time.parse(flight_date) + 1.day
    date.strftime("%d.%m.%Y")
  end

  def try_search_regular_and_lowcosts(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    # start 5 tries if search was failed
    5.times do
      choose_avia_search(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
      expect(page).not_to have_selector('.avia_recommendations__lowcosts_preloader')
      recommendation_list = find('[data-class="Avia.RecommendationsList"]')
      break if recommendation_list.has_selector?('.avia_recommendation[data-kind="regular"]') and recommendation_list.has_selector?('.avia_recommendation[data-kind="lowcost"]')
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
    end
  end

  def try_search_regular(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
    # start 5 tries if search was failed
    5.times do
      choose_avia_search(type_avia_search, params_avia_location, params_flight_dates, params_passengers)
      recommendation_list = find('[data-class="Avia.RecommendationsList"]')
      break if recommendation_list.has_selector?('[data-kind="regular"]')
      params_flight_dates[:date_departure] = increase_date_flight(params_flight_dates[:date_departure])
      params_flight_dates[:date_arrival] = increase_date_flight(params_flight_dates[:date_arrival])
    end
  end
end