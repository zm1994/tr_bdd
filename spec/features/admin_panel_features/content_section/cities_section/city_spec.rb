require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for cities in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'cities')
  end

  it 'crete city with minimum required info' do
    # delete airline if it exists
    find('#q_code').set 'CSH'
    find('[value="Фильтровать"]').click
    find('.delete_link.member_link').click if page.has_css?('.col-code', text: 'CSH')
    # create new airline
    visit($root_path_admin + 'cities/new')
    find('#city_code').set 'CSH'
    # set slug
    find('#city_slug').set 'test'
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
  end

  it 'create existed city' do
    visit($root_path_admin + 'cities/new')
    # set existed code airline
    find('#city_code').set 'HRK'
    # set slug
    find('#city_slug').set 'test'
    find('[name="commit"]').click
    expect(page).to have_selector('#city_code_input .inline-errors')
  end

  it 'delete first city' do
    first('.delete_link.member_link').click
    expect(page).to have_content('successfully destroyed')
  end
end