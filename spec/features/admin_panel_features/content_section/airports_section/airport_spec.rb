require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for airports in admin' do
  include AdminAuthHelper

  r = Random.new

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'avia_airports')
  end

  it 'crete airport with minimum required info' do
    # delete airline if it exists
    find('#q_code').set 'ZIA'
    find('[value="Фильтровать"]').click
    find('.delete_link.member_link').click if page.has_css?('.col-code', text: 'ZIA')
    # create new airline
    visit($root_path_admin + 'avia_airports/new')
    find('#avia_airport_code').set 'ZIA'
    # set slug
    find('#avia_airport_slug').set "slug#{r.rand(2...5000)}"
    # set country and city
    select('Австралия', from: 'avia_airport[country_code]')
    select('Абакан', from: 'avia_airport[city_code]')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
  end

  it 'create existed airport' do
    visit($root_path_admin + 'avia_airports/new')
    # set existed code airline
    find('#avia_airport_code').set 'DTZ'
    # set slug
    find('#avia_airport_slug').set "slug#{r.rand(2...5000)}"
    select('Австралия', from: 'avia_airport[country_code]')
    select('Абакан', from: 'avia_airport[city_code]')
    find('[name="commit"]').click
    expect(page).to have_selector('#avia_airport_code_input .inline-errors')
  end
end