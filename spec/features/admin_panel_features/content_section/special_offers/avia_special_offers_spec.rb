require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/root_path_helper'
require 'support/auth_helper'

describe 'Admin panel tests for avia special offers in admin' do
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'avia_special_offers')
  end

  it ' create avia special offer', retry: 3 do
    visit($root_path_admin + 'avia_special_offers/new?market_code=ua')
    select('Абакан', from: 'avia_special_offer[city_code]')
    find('#avia_special_offer_price_amount').set '100'
    find('#avia_special_offer_start_at').set  Time.now.strftime('%Y-%m-%d')
    find('#avia_special_offer_end_at').set  (Time.now + 5.days).strftime('%Y-%m-%d')
    find('#avia_special_offer_url').set 'https://ru.wikipedia.org/wiki/Test'
    page.attach_file('avia_special_offer[image]', Rails.root + 'spec/upload.png')
    find('[name="commit"]').click
    expect(page).to have_content('successfully created')
    visit($root_path_avia)
    expect(page).to have_selector('.special_offer__link[href="/https://ru.wikipedia.org/wiki/Test"]')
  end
end