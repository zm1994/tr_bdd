require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Admin panel tests for partners in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
  end

  it 'create new avia banner' do
    visit($root_path_admin + 'railway_search_banners/new')
    # set banners names
    find('#railway_search_banner_title_ua_ru').set 'Test Banner'
    find('#railway_search_banner_title_eu_en').set 'Test Banner'
    find('#railway_search_banner_title_ru_ru').set 'Test Banner'
    find('#railway_search_banner_title_ua_ua').set 'Test Banner'
    find('#railway_search_banner_title_us_en').set 'Test Banner'
    find('#railway_search_banner_description_ua_ru').set 'Cool Banner'
    find('#railway_search_banner_description_eu_en').set 'Cool Banner'
    find('#railway_search_banner_description_ru_ru').set 'Cool Banner'
    find('#railway_search_banner_description_ru_ru').set 'Cool Banner'
    find('#railway_search_banner_description_ua_ru').set 'Cool Banner'
    find('#railway_search_banner_description_eu_en').set 'Cool Banner'
    find('#railway_search_banner_description_ru_ru').set 'Cool Banner'
    find('#railway_search_banner_description_ua_ua').set 'Cool Banner'
    find('#railway_search_banner_description_us_en').set 'Cool Banner'
    # upload image banner
    page.execute_script("document.getElementsByName('railway_search_banner[image]')[0].style.opacity = 1")
    page.attach_file('railway_search_banner[image]', Rails.root + 'spec/upload.png')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    expect(find('img')['src']).to have_content('upload.png')
  end
end