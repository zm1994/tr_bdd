require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for countries in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'countries')
  end

  it 'create country with minimum required info' do
    # delete country if it exists
    find('#q_code').set 'DZ'
    find('[value="Фильтровать"]').click
    first('.delete_link.member_link').click if page.has_css?('.col-code', text: 'DZ')
    # create new country
    visit($root_path_admin + 'countries//new')
    find('#country_code').set 'DZ'
    find('#country_iata_code').set 'DZA'
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
  end

  it 'create existed city' do
    visit($root_path_admin + 'countries/new')
    find('#country_code').set 'DZ'
    find('#country_iata_code').set 'DZA'
    find('[name="commit"]').click
    expect(page).to have_selector('#country_code_input .inline-errors')
  end
end