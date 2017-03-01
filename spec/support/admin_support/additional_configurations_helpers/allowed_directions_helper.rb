require 'support/ajax_waiter'
module AllowedDirection
  include WaitForAjax

  def create_direction(departure_code, arrival_code)
    find('#avia_api_allowed_direction_departure_city_code').set departure_code
    find('#avia_api_allowed_direction_arrival_city_code').set arrival_code
    find('[name="commit"]').click
    wait_for_ajax
  end

  def delete_direction(departure_code, arrival_code)
    # find rule in filter
    find('#q_departure_city_code_eq').set departure_code
    find('#q_arrival_city_code_eq').set arrival_code
    find('[value="Фильтровать"]').click
    # delete if it present
    if page.has_css?('.col-departure_city_code', text: departure_code.upcase) &&
        page.has_css?('.col-arrival_city_code', text: departure_code.upcase)
      first('.delete_link').click
      expect(page).to have_content('successfully destroyed')
    end
  end
end