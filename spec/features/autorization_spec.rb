require 'rails_helper'
require 'support/auth_helper'
require 'support/firefox_driver'

describe 'Autorization' do
  include AuthHelper

  user_mail = 'test@example.com'
  user_password = 'qwerty123'

  before do
    visit('https://tripway.dev')
  end

  it 'authorization with user that doesnt exist' do
    auth_login('doesnt_exist_user@mail.ru', 'password')
    expect($modal_auth_reg_window).to have_selector('#flash_alert')
  end

  it 'authorization with valid user' do
    auth_login(user_mail, user_password)
    expect(page).not_to have_selector('.login_registration_layout-modal_dialog')
    auth_logout
  end


  it 'authorization with invalid email', js: true do
    auth_login('@mail.ru', user_password)
    expect($modal_auth_reg_window).to have_selector('.bubble_error__content')
    # expect($modal_auth_reg_window).to have_selector('#flash_alert')
    close_auth_modal

    auth_login('', user_password)
    expect($modal_auth_reg_window).to have_selector('.bubble_error__content')
    # expect($modal_auth_reg_window).to have_selector('#flash_alert')
    close_auth_modal
  end

  it 'authorization with invalid password', js: true do
    auth_login(user_mail, '')
    expect($modal_auth_reg_window).to have_selector('.bubble_error__content')
    # expect($modal_auth_reg_window).to have_selector('#flash_alert')
    close_auth_modal

    auth_login(user_mail, user_password[0...-1])
    expect($modal_auth_reg_window).to have_selector('#flash_alert')
    close_auth_modal
  end
end