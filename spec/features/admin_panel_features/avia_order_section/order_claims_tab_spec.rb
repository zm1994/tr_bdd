require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/avia_order_service_helper'
require 'support/ajax_waiter'
require 'support/claim_service_helper'

describe 'Admin panel tests for order in admin panel' do
  include AdminOrderService
  include AdminAuthHelper
  include WaitForAjax
  include ClaimService

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
  end

  it 'makes client claim and reply on it' do
    search_round = DataRoundSearch.new
    # create avia booking
    visit($root_path_avia)
    booking_round_trip(search_round)
    # create claim
    open_claim_page
    message_claim = 'Test claim'
    message_claim_reply = 'Test reply on claim'
    send_claim(message_claim)
    # open created claim in admin panel
    visit($root_path_admin_orders)
    find_order_in_admin($round_trip_booking_regular)
    open_claims_tab
    expect(page).to have_content(message_claim)
    expect(page).to have_selector('a', text: 'upload.png')
    # send reply to client
    find('[name="order_claim_message[content]"]').set message_claim_reply
    find('[value="Отправить"]').click
    wait_for_ajax
    expect(page).to have_content(message_claim_reply)
  end
end