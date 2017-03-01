require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for cities in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'footer_menus')
  end

  it 'create footer menu with minimum required info' do
    #first delete menu if exists
    find('#q_title_ua_ru').set 'test'
    find('[value="Фильтровать"]').click
    if page.has_css?('.col-title_ua_ru span', text: '• test')
      first('.delete_link.member_link')
      expect(page).to have_content('successfully destroyed')
    end
    #create new footer menu
    visit($root_path_admin + '/footer_menus/new?market_code=ua')
    find('#footer_menu_title_ua_ru').set 'test'
    find('#footer_menu_title_ua_ua').set 'test'
    find('#footer_menu_url').set 'https://ru.wikipedia.org/wiki/Test'
    find('#footer_menu_submit_action').click
    expect(page).to have_content('successfully created')
  end
end