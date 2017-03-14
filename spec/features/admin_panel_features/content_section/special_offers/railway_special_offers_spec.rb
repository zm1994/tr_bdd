require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/root_path_helper'
require 'support/auth_helper'

describe 'Admin panel tests for railway special offers in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'railway_special_offers')
  end

  it ' create avia special offer', retry: 3 do
    visit($root_path_admin + 'railway_special_offers/new?market_code=ua')
    select('Абакан', from: 'railway_special_offer[city_code]')
    find('#railway_special_offer_price_amount').set '100'
    find('#railway_special_offer_start_at').set  Time.now.strftime('%Y-%m-%d')
    find('#railway_special_offer_end_at').set  (Time.now + 5.days).strftime('%Y-%m-%d')
    find('#railway_special_offer_url').set 'https://ru.wikipedia.org/wiki/Test'
    page.attach_file('railway_special_offer[image]', Rails.root + 'spec/upload.png')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    visit($root_path_railway)
    expect(page).to have_selector('.special_offer__link[href="/https://ru.wikipedia.org/wiki/Test"]')
  end
end