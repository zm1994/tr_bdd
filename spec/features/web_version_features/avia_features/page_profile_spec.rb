require 'rails_helper'
require 'support/auth_helper'
require 'support/user_profile_helper'
require 'support/root_path_helper'

require 'rails_helper'

describe "My profile" do
  include AuthHelper
  include UserProfile

  user_mail = 'test@example.com'
  user_password = 'qwerty123'

  before do
    visit($root_path_avia)
    find('[href="/profile/login"]').click
    auth_login(user_mail, user_password)
    open_my_profile
  end

  it "change personal information" do
    expect(find('#registration_email[disabled="disabled"]').value == user_mail).to be true
    personal_info = {first_name: 'Firstname', last_name: 'Lastname', address: 'Test st', tel: '+380 99 435 344'}
    change_personal_info(personal_info)
    check_personal_info(personal_info)
  end

  # it "change password"
  # it "check that user be authorised with new password"
  # it "reset new password to old" do
  #   old_password = user_password
  #   new_password = user_password+"1"
  #
  #   open_my_profile
  #   change_personal_password(old_password,new_password)
  #   expect(page).to have_selector('.flash__messages_list')
  #   auth_logout
  #
  #   auth_login(user_mail, new_password)
  #   expect(page).to have_content("#{$part_email}")
  #   open_my_profile
  #
  #   old_password, new_password = new_password, old_password
  #   change_personal_password(old_password,new_password)
  # end

  it "checking wrong inputs passwords" do
    old_password = user_password + 'qw'
    new_password = user_password + '1'
    change_personal_password(old_password, new_password)
    expect(page).to have_selector('.bubble_error__content') # change password with wrong input current password

    old_password = user_password
    change_personal_password(old_password, new_password, new_password+'1')
    expect(page).to have_selector('.bubble_error__content')  # change password with input new password which are different with confirmation password

    change_personal_password('', new_password)
    expect(page).to have_selector('.bubble_error__content')  #change password without input current password"
  end
end


describe 'My passengers' do
  include AuthHelper
  include ProfileEditPassengers

  user_mail = 'test@example.com'
  user_password = 'qwerty123'

  before do
    visit($root_path_avia)
    find('[href="/profile/login"]').click
    auth_login(user_mail, user_password)
    open_my_passengers
  end

  it 'add new passenger', retry: 3 do
    passenger = {gender: 1,               #man
                 first_name: 'FIRSTNAME',
                 last_name: 'LASTNAME',
                 birthday: '12121990',
                 passport: 'CL234352',
                 passport_expire: '16162017'}

    add_new_passenger(passenger)
  end

  it 'delete last passenger', retry: 3 do
    # count passengers
    expect(page).to have_selector('#edit_user')
    initial_count_pass = all("#edit_user .fields ul").size
    if initial_count_pass > 0
      passenger = all('#edit_user .fields').last
      passenger.find('.remove a').click
      find('.modal_dialog__background_theme-confirmation [data-confirmation-action="confirm"]').click
      expect(page).not_to have_selector('.modal_dialog__background')
      expect(page).not_to have_selector('.modal_dialog__preloader')
      expect(all("#edit_user .fields ul").size < initial_count_pass).to be true
    end
  end
end
