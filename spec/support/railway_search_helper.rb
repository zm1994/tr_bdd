module RailWaySearch
  $url_avia_recommendation = ""

  def choose_popular_cities_in_form_search(city_departure, city_arrival)
    find('.railway_popular_stations__list-from .railway_popular_stations__station_link', text: city_departure).click
    find('.railway_popular_stations__list-to .railway_popular_stations__station_link', text: city_arrival).click
  end

  def choose_date_departure(date)
    page.execute_script("$('#railway_search_departure_date').val(\'#{date}\')")
  end

  def increase_date_departure(date)
    unless date.nil?
      date = Time.parse(date) + 1.day
      date.strftime("%d.%m.%Y")
    end
  end

  def get_current_date
    Time.now.strftime("%d.%m.%Y")
  end

  def input_params_search(city_departure, city_arrival, date_departure)
    choose_popular_cities_in_form_search(city_departure, city_arrival)
    choose_date_departure(date_departure)
  end

  def try_railway_search(city_departure, city_arrival, date_departure)
    5.times do
      input_params_search(city_departure, city_arrival, date_departure)
      find('.railway_search_form__theme-homepage [type="submit"]').click
      break unless recomendations_not_available?
      date_departure = increase_date_departure(date_departure)
    end

    expect(page).to have_selector('[data-class="Railway.RecommendationsList"]')
    page.current_url
  end

  def open_page_recommendation(city_departure, city_arrival, date_departure)
    if $url_avia_recommendation.length > 0
      visit($url_avia_recommendation)
    else
      try_railway_search(city_departure, city_arrival, date_departure)
    end
  end

  def recomendations_not_available?
    if page.has_css?('.notify_message__action_link_layout-modal_dialog')
      find('[href="/railway"]').click
      true
    else
      false
    end
  end
end