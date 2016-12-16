require 'rails_helper'
require 'support/auth_helper'
require 'support/root_path_helper'
require 'support/page_helper'
require 'support/user_profile_helper'
require 'support/avia_search_helper'
require 'support/avia_booking_helper'
require 'support/avia_test_data_helper'
require 'support/avia_booking_service_helper'

describe 'Claim' do
  include AuthHelper
  include ProfileAviaBookings
  include AviaSearch
  include AviaBooking
  include AviaBookingService

  user_mail = 'test@example.com'
  user_password = 'qwerty123'
  search_round = DataRoundSearch.new

  before do
    visit($root_path_avia)
  end

  it 'make claim in order' do
    # first make an order round trip
    unless ($round_trip_booking_regular.empty?)
      auth_login(user_mail, user_password)
      open_my_orders
      open_booking_page($round_trip_booking_regular)
      else
      booking_round_trip(search_round)
    end
    # got to the claim form
    find('.order__claims_link').click
    expect(page).to have_selector('.column_width-narrow')
    find('.column_width-wide>div.active textarea.input').set 'Test request'
    find('.column_width-wide>div.active [type="submit"]').click
    if(page.has_css?('.confirmation_message__action_link_layout-modal_dialog'))
      find('[data-confirmation-action="confirm"]').click
    end
    expect(page).to have_selector('.notify_message')
    find('.notify_message__action_link').click
    chat_area = find('.column_width-wide>div.active .order_claim_messages')
    expect(chat_area).to have_content('Test')
    # page.attach_file('.column_width-wide>div.active [type="file"]', Rails.root + "spec/files_for_upload/test_png.png")
  end
end