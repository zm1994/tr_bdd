require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/auth_helper'

describe 'Admin panel tests for partners section' do
  include AdminAuthHelper
  include AuthHelper

  r = Random.new

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    # puts $root_path_admin + 'users'
    visit($root_path_admin + 'partners')
  end

  it 'create new partner with minimum required info' do
    # create new partner
    partner_email = 'test' + r.rand(1...5000).to_s + '@example.com'
    partner_password = 'password'
    find('[href="/cockpit/partners/new"]').click
    find('#partner_agency_name').set 'Test partners name'
    find('#partner_email').set partner_email
    find('#partner_password').set partner_password
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    # check that partner can login on site
    visit($root_path_avia)
    find('[href="/profile/login"]').click
    auth_login(partner_email, partner_password)
    auth_logout_web(partner_email)
  end

  it 'set juridical name without registration number' do
    first('.edit_link.member_link').click
    find('#partner_company_name').set 'Test company name'
    find('[name="commit"]').click
    # check registration number cant be empty
    expect(page).to have_selector('#partner_company_registration_number_input .inline-errors')
  end

  it 'set registration number without juridical name' do
    # open first agent
    first('.edit_link.member_link').click
    find('#partner_company_registration_number').set '12345678'
    find('[name="commit"]').click
    # check partner be empty
    expect(page).to have_selector('#partner_company_name_input .inline-errors')
  end

  it 'update partner contract by filling required fields' do
    # open first agent
    first('.edit_link.member_link').click
    find('#partner_company_name').set 'Test company'
    find('#partner_company_registration_number').set '12345678'
    find('#partner_contract_number').set '00000000/00ВІ'
    find('#partner_contract_signed_at').set '2017-02-21'
    find('#partner_contract_award').set '1'

    find('[name="commit"]').click
    # check partner be empty
    expect(page).to have_content('successfully updated')
  end

  it 'update partner contract without partner company name' do
    # open first agent
    first('.edit_link.member_link').click
    find('#partner_company_name').set '' # empty field
    find('#partner_company_registration_number').set '12345678'
    find('#partner_contract_number').set '00000000/00ВІ'
    find('#partner_contract_signed_at').set '2017-02-21'
    find('#partner_contract_award').set '1'

    find('[name="commit"]').click
    # check partner be empty
    expect(page).to have_selector('#partner_company_name_input .inline-errors')
  end

  it 'update partner contract without registration number' do
    # open first agent
    first('.edit_link.member_link').click
    find('#partner_company_name').set 'Test company'
    find('#partner_company_registration_number').set '' # empty field
    find('#partner_contract_number').set '00000000/00ВІ'
    find('#partner_contract_signed_at').set '2017-02-21'
    find('#partner_contract_award').set '1'

    find('[name="commit"]').click
    # check partner be empty
    expect(page).to have_selector('#partner_company_registration_number_input .inline-errors')
  end

  it 'update partner contract without contract number' do
    # open first agent
    first('.edit_link.member_link').click
    find('#partner_company_name').set 'Test company'
    find('#partner_company_registration_number').set '12345678'
    find('#partner_contract_number').set '' # empty field
    find('#partner_contract_signed_at').set '2017-02-21'
    find('#partner_contract_award').set '1'

    find('[name="commit"]').click
    # check partner be empty
    expect(page).to have_selector('#partner_contract_number_input .inline-errors')
  end

  it 'update partner contract without contract signed at' do
    # open first agent
    first('.edit_link.member_link').click
    find('#partner_company_name').set 'Test company'
    find('#partner_company_registration_number').set '12345678'
    find('#partner_contract_number').set '00000000/00ВІ'
    find('#partner_contract_signed_at').set '' # empty field
    find('#partner_contract_award').set '1'

    find('[name="commit"]').click
    # check partner be empty
    expect(page).to have_selector('#partner_contract_signed_at_input .inline-errors')
  end
end