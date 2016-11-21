module RailwayBooking
  def input_passenger_info(params_passenger)
    #input last name, first name
    find('.railway_preorder_passengers_lastname .input').set params_passenger[:last_name]
    find('.railway_preorder_passengers_firstname .input').set params_passenger[:first_name]
    if(params_passenger[:type_passenger] == 'student')
      input_student_document(params_passenger[:preferential_document])
    else
      if(params_passenger[:type_passenger] == 'child')
        choose_child_age(params_passenger[:age])
      end
    end
  end

  def input_payer_info(params_payer)
    find('.railway_preorder_payer_full_name input').set params_payer[:full_name]
    find('.railway_preorder_payer_email input').set params_payer[:email]
    find('.intl-tel-input input').set params_payer[:telephone]
  end

  def open_passenger_block_input(type_wagon)
    expect(page).to have_selector('.variant_price')
    if type_wagon.length > 0
      # find parent of the selector with name type_wagon, which contained button to open block with wagons
      car = first('.variant_wagon_type', text: type_wagon).find(:xpath, '..').find(:xpath, '..')
      car.find('.railway_recommendation_details__variant_details_colon a').click
    else
      # find first available car and seat on the page recommendation
      first('.railway_recommendation_details__variant_details_colon a').click
    end
    expect(page).to have_selector('.wagon_place.available')
    first('.wagon_place.available:not(.selected)').click
    expect(page).to have_selector('[data-class="Railway.PreorderForm.Passenger"]')
    # return
    find('[data-class="Railway.PreorderForm"]')
  end

  def input_student_document(preferential_document)
    # click and choose student rom list in passenger block
    select_type_passenger('Студент')
    find('.railway_preorder_passengers_student_card_id input').set preferential_document
  end

  def select_type_passenger(type_passenger)
    find('.select2-choice').click
    find('.select2-result-label', text: type_passenger).click
  end

  def choose_child_age(age)
    select_type_passenger('Ребенок')
    find('.railway_preorder_passengers_child_age').click
    find('.select2-result-label', text: age).click
  end

  def open_preorder_page
    # click submit from page recommendation
    # pry.binding
    find('button[type="submit"]').click
    expect(page).not_to have_selector('.notify_message_layout-modal_dialog')
    expect(page).to have_selector('.railway_order')
    page.current_url
  end

  def try_booking
    # click on submit button
    find('.railway_order_form__button').click
    expect(page).not_to have_selector('.notify_message_layout-modal_dialog')
    expect(page).to have_selector('.sng__liqpay__power')
    find('.cancel__payment a').click
    expect(page).to have_selector('.railway_order')
  end
end