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
    expect(page).to have_selector('[data-class="Railway.RecommendationsList"]')
  end

  def recomendations_not_available?
    if page.has_css?('.notify_message__action_link_layout-modal_dialog')
      find('[href="/railway"]').click
      true
    else
      false
    end
  end

  def check_all_wagons_on_page_recommendation
    # remove block search by correct parsing page recommendations
    page.execute_script("$('.sticky_search__stick_block').remove()")
    # find all variants in page recommendation
    all('[data-role="variant_shortcut.select"]').each do |variant|
      variant.click
      expect(page).to have_selector('.wagon_template_container')
      all('.wagon_list__item_number').each do |wagons_list__item|
        if(wagons_list__item.visible?)
          wagons_list__item.click
          expect(page).not_to have_selector(".wagon_temlate_preloader")
          wagon_container = find('.wagon_template_container')
          # if wagon container doesn't contain drawing wagon make screenshot
          unless wagon_container.has_selector?('.wagon_place.available')
            screenshot_and_save_page
            break
          else
            # get count available seats in list item and compare it with count available seats in wagon
            count_available_seats_in_list_item = find('.wagons_list__item.selected .wagon_list__item_available_places').text.to_i
            unless check_count_available_seats_in_wagon(count_available_seats_in_list_item)
              screenshot_and_save_page
              break
            end
          end
        end
      end
    end
  end

  def check_count_available_seats_in_wagon(list_item_seats)
    wagon = find('.wagon_template', visible: true)
    count_seats_in_wagon = wagon.all('.wagon_place.available').count
    list_item_seats.equal?(count_seats_in_wagon)
  end
end