require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for countries in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'press')
  end

  it 'create press with minimum required info' do
    visit($root_path_admin + 'press/new?market_code=ua')
    find('#press_title_ua_ru').set 'test'
    find('#press_title_ua_ru').set 'test'
    page.attach_file('press[logo]', Rails.root + 'spec/upload.png')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    visit($root_path_avia)
  end

  it 'delete first press' do
    first('.delete_link.member_link').click
    expect(page).to have_content('successfully destroyed')
  end
end