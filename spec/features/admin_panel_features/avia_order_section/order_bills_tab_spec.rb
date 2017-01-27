require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/avia_order_service_helper'
require 'support/ajax_waiter'

describe 'Tests for order in admin panel' do
  include AdminOrderService
  include AdminAuthHelper
  include WaitForAjax

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
  end

  it 'makes full payment manually' do
    open_round_trip_order_in_admin
    amount_to_pay = get_order_amount
    pay_gateway = get_current_payment_gateway
    open_bills_tab
    set_payment(amount_to_pay, pay_gateway, true)
    wait_for_ajax
    expect(get_paid_amount == amount_to_pay).to be true
    expect(get_amount_to_pay == 0).to be true
  end

  it 'makes payment manually and delete payment' do
    open_round_trip_order_in_admin
    amount_to_pay = get_order_amount
    pay_gateway = get_current_payment_gateway
    open_bills_tab
    set_payment(amount_to_pay, pay_gateway, true)
    wait_for_ajax
    first('[href*="remove_bill_payment"]').click
    wait_for_ajax
    expect(get_amount_to_pay == amount_to_pay).to be true
  end
end