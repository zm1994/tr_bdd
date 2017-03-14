require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for popular menu in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'populars_menus')
  end

  it 'create country with minimum required info and delete it' do
    visit($root_path_admin + 'populars_menus/new?market_code=ua')
    # set title
    find('#populars_menu_title_ua_ru').set 'test'
    find('#populars_menu_title_ua_ua').set 'test'
    # set link to page
    find('#populars_menu_url').set 'https://ru.wikipedia.org/wiki/Test'
    find('[name="commit"]').click
    expect(page).to have_content('successfully created.')
    #delete popular item
    find('[data-method="delete"]').click
    expect(page).to have_content('successfully destroyed')
  end
end