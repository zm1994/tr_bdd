require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/avia_order_service_helper'
require 'support/ajax_waiter'

describe 'Admin panel tests for order in admin panel' do
  include AdminOrderService
  include AdminAuthHelper
  include WaitForAjax

  r = Random.new

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    open_round_trip_order_in_admin
  end

  it 'increase fare in order and send to incomes' do
    # find first fare of passenger and increase it
    fare_passenger_elem = first('[id*="passengers_attributes_0_fare"]')
    fare_increase = r.rand(100 ... 500)
    increase_fare(fare_passenger_elem, fare_increase)
    find('[value="Считать расходом"]').click
    wait_for_ajax
    open_incomes_tab
    # check that amount increased on fare_increase
    expect(page).to have_content("-#{fare_increase}")
  end

  it 'decrease fare and send to incomes' do
    # find first fare of passenger and increase it
    fare_passenger_input = first('[id*="passengers_attributes_0_fare"]')
    fare_decrease = r.rand(100 ... 500)

    decrease_fare(fare_passenger_input, fare_decrease)
    find('[value="Считать доходом"]').click
    wait_for_ajax
    open_incomes_tab
    expect(page).to have_content("#{fare_decrease}")
  end

  it 'makes incomes manually' do
    open_incomes_tab
    amount = r.rand(100 ... 500)
    find('#order_manual_income_amount').set amount
    find('[value="Внести запись"]').click
    wait_for_ajax
    expect(page).to have_content(amount)
  end

  it 'makes incomes manually and delete it' do
    open_incomes_tab
    amount_incomes = r.rand(100 ... 500)
    find('#order_manual_income_amount').set amount_incomes
    find('[value="Внести запись"]').click
    wait_for_ajax
    expect(page).to have_content(amount_incomes)
    # find checkbox last added incomes
    all('[id*="destroy"]').last.click
    find('[value="Обновить данные о доходах"]').click
    wait_for_ajax
    expect(page).not_to have_content(amount_incomes)
  end
end