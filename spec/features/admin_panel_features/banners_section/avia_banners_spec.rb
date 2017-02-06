require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/auth_helper'

describe 'Tests for partners in admin' do
  include AdminAuthHelper
  include AuthHelper

  r = Random.new

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
  end

  it 'create new avia banner' do
    visit($root_path_admin + 'avia_search_banners/new')
    find('#avia_search_banner_title_ua_ru').set 'Test Banner'
    find('#avia_search_banner_title_eu_en').set 'Test Banner'
    find('#avia_search_banner_title_ru_ru').set 'Test Banner'
    find('#avia_search_banner_title_ua_ua').set 'Test Banner'
    find('#avia_search_banner_title_us_en').set 'Test Banner'
    find('#avia_search_banner_description_ua_ru').set 'Cool Banner'
    find('#avia_search_banner_description_eu_en').set 'Cool Banner'
    find('#avia_search_banner_description_ru_ru').set 'Cool Banner'
    find('#avia_search_banner_description_ru_ru').set 'Cool Banner'
    find('#avia_search_banner_description_ua_ru').set 'Cool Banner'
    find('#avia_search_banner_description_eu_en').set 'Cool Banner'
    find('#avia_search_banner_description_ru_ru').set 'Cool Banner'
    find('#avia_search_banner_description_ua_ua').set 'Cool Banner'
    find('#avia_search_banner_description_us_en').set 'Cool Banner'
    page.attach_file(locator, Rails.root + '/spec/upload.png')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
  end
end