require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/auth_helper'

describe 'Admin panel tests for railway stations in admin' do
  include AdminAuthHelper
  include AuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'railway_stations')
  end

  it 'crete railway stations with minimum required info' do
    # delete airline if it exists
    find('#q_code').set '6700841'
    find('[value="Фильтровать"]').click
    find('.delete_link.member_link').click if page.has_css?('.col-code', text: '6700841')
    # create new airline
    visit($root_path_admin + 'railway_stations/new')
    find('#railway_station_code').set '6700841'
    select('Украина', from: 'railway_station[country_code]')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
  end

  it 'create existed railway stations' do
    visit($root_path_admin + 'railway_stations/new')
    # set existed code airline
    find('#railway_station_code').set '2200001'
    select('Украина', from: 'railway_station[country_code]')
    find('[name="commit"]').click
    expect(page).to have_selector('#railway_station_code_input .inline-errors')
  end

  it 'create station with empty fields' do
    visit($root_path_admin + 'railway_stations/new')
    find('[name="commit"]').click
    expect(page).to have_selector('#railway_station_code_input .inline-errors')
    expect(page).to have_selector('#railway_station_country_input .inline-errors')
  end
end