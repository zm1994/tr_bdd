module UserProfile

  def change_personal_info(new_personal_info={})
    find('#registration_firstname').set new_personal_info.fetch(:first_name)
    find('#registration_lastname').set new_personal_info.fetch(:last_name)
    find('#registration_address').set new_personal_info.fetch(:address)
    find('#registration_phone').set new_personal_info.fetch(:tel)
    first('.button.big').click
  end

  def check_personal_info(personal_info={})
    expect(find('#registration_firstname').value).to eq(personal_info[:first_name])
    expect(find('#registration_lastname').value).to eq(personal_info[:last_name])
    expect(find('#registration_address').value).to eq(personal_info[:address])
    expect(find('#registration_phone').value).to eq(personal_info[:tel])
  end

  def change_personal_password(old_password, new_password, confim_password = new_password)
    find('#registration_current_password').send_keys old_password
    find('#registration_password').send_keys new_password
    find('#registration_password_confirmation').send_keys confim_password
    find('.profile-change-password .button.big').click
  end
end

module ProfileAviaBookings

  def check_booking(reservation_code = '', number_in_filter = 1)
    if reservation_code.size > 0
      find('.avia-user-bookings .reservation-code', text: "#{reservation_code}").click
    elsif find(".avia-user-bookings div:nth-of-type(#{number_in_filter}).avia-user-booking").present?
      find(".avia-user-bookings div:nth-of-type(#{number_in_filter}).avia-user-booking").click
    end

    expect(page).to have_selector('.avia_booking__itineraries_list')
  end

  # def filter_by_code(reservation_code)
  #   count_without_filter = all('.avia-user-booking').count
  #
  #   if count_without_filter > 0
  #     find('#avia_user_bookings_filter .reservation-code input').set reservation_code
  #
  #     page.should have_selector('.avia-user-bookings .reservation-code', count: 1)
  #     page.should have_selector('.avia-user-bookings .reservation-code', text: "#{reservation_code}")
  #   end
  # end
  #
  # def filter_by_date_trip(date_from = '', date_to = '')
  #   count_without_filter = all('.avia-user-booking').count
  #
  #   if count_without_filter > 0
  #     if date_from.size > 0
  #       find('.from-date input').set date_from
  #     end
  #     if date_to.size > 0
  #       find('.to-date input').set date_to
  #     end
  #     if find('.avia-user-bookings .reservation-code').present?
  #       expect(page).to have_selector('.avia-user-bookings .reservation-code', :count <= count_without_filter )
  #     end
  #   else
  #     raise 'there is no bookings'
  #   end
  # end
  #
  # def clean_filter
  #   count_with_filter = all('.avia-user-booking').count
  #
  #   if count_with_filter.size > 0
  #     find('.from-date input').set ''
  #     find('.to-date input').set ''
  #     find('#avia_user_bookings_filter .reservation-code input').set ''
  #
  #     expect(page).to have_selector('.avia-user-bookings .reservation-code', :count >= count_with_filter )
  #   end
  # end

  def open_booking_page(code_booking = '')
    find('.orders_list__cell-for_code', contains: code_booking).click
    expect(page).to have_selector('.avia_order')
  end

end

module ProfileEditPassengers

  def add_new_passenger(passenger_info = {})
    find('.add-passenger.add_nested_fields').click
    field_new_pass = find('#new_passenger')
    field_new_pass.find(".gender li:nth-of-type(#{passenger_info[:gender]}).radio").click
    field_new_pass.find('.lastname input').send_keys passenger_info[:last_name]
    field_new_pass.find('.firstname input').send_keys passenger_info[:first_name]
    field_new_pass.find('.birth_date input').click #passenger_info.fetch(:birthday)
    field_new_pass.find('.birth_date input').set passenger_info[:birthday]
    field_new_pass.find('.passport_number input').send_keys passenger_info[:passport]
    field_new_pass.find('.passport_expires_at input').click #passenger_info.fetch(:passport_expire)
    field_new_pass.find('.passport_expires_at input').set passenger_info[:passport_expire]
    find('.button.big').click


    # expect(field_new_pass.find('.lastname input').value).to eq(passenger_info[:last_name])
    # expect(field_new_pass.find('.firstname input').value).to eq(passenger_info[:first_name])
    # expect(field_new_pass.find('.birth_date input').value).to eq(passenger_info[:birthday])
    # expect(field_new_pass.find('.passport_number input').value).to eq(passenger_info[:passport])
    # expect(field_new_pass.find('.passport_expires_at input').value).to eq(passenger_info[:passport_expire])
  end

  def delete_passenger(first_name = '')
    if first_name.size > 0 and last_name.size > 0
      field_remove_pass = find('ul[id*="passenger"]', text: first_name)
      field_remove_pass.find('.remove a').click
    end
  end
end