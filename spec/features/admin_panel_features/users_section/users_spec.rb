require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for users section' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    # puts $root_path_admin + 'users'
    visit($root_path_admin + 'users')
    first('.edit_link.member_link').click
  end

  it 'set juridical name without registration number' do
    find('#user_company_name').set 'Test company name'
    find('#user_company_registration_number').set ''
    find('[name="commit"]').click
    # check registration number cant be empty
    expect(page).to have_selector('#user_company_registration_number_input .inline-errors')
  end

  it 'set registration number without juridical name' do
    find('#user_company_name').set ''
    find('#user_company_registration_number').set '12345678'
    find('[name="commit"]').click
    # check сompany name cant be empty
    expect(page).to have_selector('#user_company_name_input .inline-errors')
  end

  it 'set wrong registration number' do
    find('#user_company_name').set 'Test company name'
    # valid registration number is 12345678
    find('#user_company_registration_number').set '1234567'
    find('[name="commit"]').click
    # check сompany name cant be empty
    expect(page).to have_selector('#user_company_registration_number_input .inline-errors')
  end
end