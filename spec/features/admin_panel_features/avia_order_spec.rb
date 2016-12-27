require 'support/admin_support/avia_order_service_helper'

describe 'Check order', js:true do
  include AdminOrderService

  it 'open round trip order' do
    open_round_trip_order
  end
end