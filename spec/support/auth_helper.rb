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
    $part_email = crop_email(user_mail)
  end

  def crop_email(mail)
    if mail.size > 0
      mail.split('@')[0] + '@'
    end
  end

  def auth_from_booking_page(user_mail, user_pass, mobile_version = false)
    if mobile_version
      find('.passengers_auth__login_link').click
    else
      find('.order_form__sign_in_link').click
    end
    auth_login(user_mail, user_pass)
    expect(page).not_to have_selector('.login_registration__forms')
    expect(page).not_to have_selector('.modal_dialog__preloader')
  end

  def auth_logout_web(email)
    part_mail = crop_email(email)
    find(".header_profile__username_link", text: "#{part_mail}").click
    find('a[href="/profile/logout"]').click
    expect(page).to have_selector('.header_profile__sign_in_link')
  end

  def auth_logout_mobile
    expect(page).to have_selector('.avia_search_form__theme-mobile_homepage')
    # click hamburger menu
    find('.mobile_header_action__select-menu').click
    # check that user autorised, find link to orders this user
    expect(page).to have_selector('.hamburger__items')
    find('[href="/profile/logout"]').click
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
    find('.dropdown__menu_items [href="/orders"]').click      #open booking page and redirect to passengers
    find('[href="/profile/passengers"]').click
  end

  def open_my_bonuses
    find('.dropdown__menu_items [href="/profile/bookings"]').click
    find(text: 'История бонусов').click
    expect(page).to have_selector('#bonus_account__amount')
  end
end

