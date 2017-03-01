require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for airlines in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'avia_airlines')
  end

  it 'crete airline with minimum required info' do
    # delete airline if it exists
    find('#q_code').set 'LO'
    find('[value="Фильтровать"]').click
    find('.delete_link.member_link').click if page.has_css?('.col-code', text: 'LO')
    # create new airline
    visit($root_path_admin + 'avia_airlines/new')
    find('#avia_airline_code').set 'LO'
    # set slug
    find('#avia_airline_slug').set 'test'
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
  end

  it 'create existed airline' do
    visit($root_path_admin + 'avia_airlines/new')
    # set existed code airline
    find('#avia_airline_code').set 'PS'
    # set slug
    find('#avia_airline_slug').set 'test'
    find('[name="commit"]').click
    expect(page).to have_selector('#avia_airline_code_input .inline-errors')
  end

  it 'delete first airline' do
    first('.delete_link.member_link').click
    expect(page).to have_content('successfully destroyed')
  end
end