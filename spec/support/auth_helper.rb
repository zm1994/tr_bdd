module AuthHelper
  $part_email = ""

  def auth_login(user_mail, user_pass)
    $modal_auth_reg_window = find('.modal_dialog__content .login_registration')

    if user_mail.size > 0
      $modal_auth_reg_window.find('#user_email').set user_mail
    end

    if user_pass.size > 0
      $modal_auth_reg_window.find('#user_password').set user_pass
    end

    find('.login_registration .button_layout-modal_dialog').click

    if user_mail.size > 0
      $part_email = user_mail.split('@')[0] + '@'
    end
  end

  def auth_from_booking_page(user_mail, user_pass)
    find('.avia_order_form__sign_in_link').click
    auth_login(user_mail, user_pass)
    expect(page).not_to have_selector('.login_registration__forms')
    expect(page).not_to have_selector('.modal_dialog__preloader')
  end

  def auth_logout
    find(".header_profile__username_link", text: "#{$part_email}").click
    find('a[href="/profile/logout"]').click
    expect(page).to have_selector('.header_profile__sign_in_link')
  end

  def close_auth_modal
    find('.modal_dialog__close').click
    expect(page).not_to have_selector('.login-registration.tab-content_layout-modal_dialog')
  end

  def open_my_profile
    find(".header_profile__username_link", text: "#{$part_email}").click
    find('[href="/profile/edit"]').click
    expect(page).to have_selector('#edit_registration')
  end

  def open_my_orders
    find(".header_profile__username_link", text: "#{$part_email}").click
    find('.dropdown__menu_items [href="/profile/bookings"]').click
    expect(page).to have_selector('#avia_user_bookings_filter')
  end

  def open_my_passengers
    find(".header_profile__username_link", text: "#{$part_email}").click
    find('.dropdown__menu_items [href="/avia/orders"]').click      #open booking page and redirect to passengers
    find('[href="/profile/passengers"]').click
  end

  def open_my_bonuses
    find('.dropdown__menu_items [href="/profile/bookings"]').click
    find(text: 'История бонусов').click
    expect(page).to have_selector('#bonus_account__amount')
  end
end

