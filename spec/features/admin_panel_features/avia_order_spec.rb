require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/avia_order_service_helper'

describe 'Tests for order in admin panel' do
  include AdminOrderService
  include AdminAuthHelper

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
  end

  it 'open round trip order in admin', retry: 3 do
    open_round_trip_order_in_admin
  end
end

