require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'
require 'support/page_helper'

$array_web_mobile_root_path.each do |root_path|
  describe 'Autorization/Registration' do
    include AuthHelper

    user_mail = 'test@example.com'
    user_password = 'qwerty123'

    before do
      visit(root_path)
      if(root_path == $root_path_avia)
        find('[href="/profile/login"]').click
      elsif(root_path == $root_path_mobile_avia)
        find('.mobile_header_action__select-menu').click
        expect(page).to have_selector('.hamburger__items')
        find('[href="/profile/login"]').click
      end
    end

    it 'authorization with user that doesnt exist' do
      puts root_path
      auth_login('doesnt_exist_user@mail.ru', 'password')
      expect($modal_auth_reg_window).to have_selector('#flash_alert')
    end

    it 'authorization with valid user' do
      auth_login(user_mail, user_password)
      if(root_path == $root_path_avia)
        expect(page).not_to have_selector('.login_registration_layout-modal_dialog')
        auth_logout_web(user_mail)
      elsif(root_path == $root_path_mobile_avia)
        auth_logout_mobile
      end
    end

    it 'authorization with invalid email', js:true do
      auth_login('@mail.ru', user_password)
      expect($modal_auth_reg_window).to have_selector('.bubble_error__content')
      # expect($modal_auth_reg_window).to have_selector('#flash_alert')
      close_auth_modal
    end

    it 'authorization with no email', js: true do
      auth_login('', user_password)
      expect($modal_auth_reg_window).to have_selector('.bubble_error__content')
      # expect($modal_auth_reg_window).to have_selector('#flash_alert')
      close_auth_modal
    end

    it 'authorization with invalid password', js:true do
      auth_login(user_mail, user_password[0...-1])
      expect($modal_auth_reg_window).to have_selector('#flash_alert')
      close_auth_modal
    end

    it 'authorization with no password', js:true do
      auth_login(user_mail, '')
      expect($modal_auth_reg_window).to have_selector('.bubble_error__content')
      # expect($modal_auth_reg_window).to have_selector('#flash_alert')
      close_auth_modal
    end

    it 'registrate new user' do
      find('[href="/profile/sign_up#registration"]').click
      random_number = Random.new
      user_registrate_mail = 'test_registrate_user' + random_number.rand(0...5000).to_s + '@example.com'
      find('.registration_email input').set user_registrate_mail
      find('.registration_password input').set user_password
      find('.registration_password_confirmation input').set user_password
      find('.registration_form__actions_layout-modal_dialog').click
      expect(page).not_to have_selector('.modal_dialog__preloader')
      expect(page).not_to have_selector('.login_registration_layout-modal_dialog')
      expect(page).to have_selector('.avia_search_form__segments')
      if(root_path == $root_path_avia)
        auth_logout_web(user_registrate_mail)
      elsif(root_path == $root_path_mobile_avia)
        auth_logout_mobile
      end
    end

    it 'check when user forget his password' do
      # click link to recover passw
      find('a.login_form__recover_password_layout-modal_dialog').click
      expect(page).to have_selector('.user_recover_password_layout-modal_dialog')
      # input in modal dialog email
      find('.input_layout-modal_dialog input').set user_mail
      expect(page).to have_selector('.user_recover_password_form__actions_layout-modal_dialog [type="submit"]')
      find('.user_recover_password_form__actions_layout-modal_dialog [type="submit"]').click
      expect(page).to have_selector('.flash__message_content_theme-notice')
      expect(page_broken?).to be false
    end
  end
end