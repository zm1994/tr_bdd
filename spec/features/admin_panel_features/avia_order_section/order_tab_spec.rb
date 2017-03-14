require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/avia_order_service_helper'
require 'support/ajax_waiter'

describe 'Admin panel tests for order in admin panel' do
  include AdminOrderService
  include AdminAuthHelper
  include WaitForAjax

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    open_round_trip_order_in_admin
  end

  it 'change sms package' do
    # find link sms package
    find('#order_items_tab table tbody tr:nth-of-type(2) a').click
    select('SMS-уведомление в случае отмены или переноса рейса', from: 'item_element_switcher[element_id]')
    find('[value="Обновить"]').click
    wait_for_ajax
    amount_sms =  find('#order_items_tab tbody tr:nth-of-type(2) td:nth-of-type(8)').text.split(' ').first.to_f
    expect(amount_sms > 0).to be true
  end

  it 'change package guarantee back package' do
    find('a', text: 'МИНИМАЛЬНЫЙ').click
    select('ОПТИМАЛЬНЫЙ', from: 'item_element_switcher[element_id]')
    find('[value="Обновить"]').click
    wait_for_ajax
    amount_sms =  find('#order_items_tab tbody tr:nth-of-type(3) td:nth-of-type(8)').text.split(' ').first.to_f
    expect(amount_sms > 0).to be true
  end

  it 'split order' do
    # click on split
    find('.fa-scissors').click
    # set name splitted order
    find('#avia_booking_splitter_new_reservation_code').set 'SPLITTER'
    # choose second passenger
    find('.choice:nth-of-type(2) input').click
    find('[value="Cплитовать"]').click
    wait_for_ajax
    expect(page).to have_selector('[href*="#avia_amadeus_booking"]', text: 'SPLITTER')
  end

  it 'change payer type on juridical' do
    open_order_payer_tab
    select('Юридическое лицо', from: 'order_payer[payer_type]')
    find('#order_payer_email').set 'test@test.ua'
    find('#order_payer_company_name').set 'TEST COMPANY'
    find('#order_payer_company_registration_number').set '12345678'
    find('[value="Обновить"]').click
    wait_for_ajax
    open_order_items_tab
    expect(get_subagent_reward > 0).to be true
  end

  it 'set bonuses manually' do
    open_order_owner_tab
    find('#bonus_transaction_amount').set '1000'
    find('[value="Провести"]').click
    wait_for_ajax
    expect(get_order_bonuse_amount == 1000).to be true
  end

  it 'set bonuses by system' do
    expected_bonuses = (get_order_amount * 0.01).round(2)
    open_order_owner_tab
    find('a', text: 'Выполнить').click
    expect(page).to have_content(expected_bonuses)
  end

  it 'change type payment gateway to online gateway' do
    init_bill = get_current_bill
    open_order_tools_tab
    select('Webmoney', from: 'switch_payment_gateway[id]')
    find('[value="Изменить"]').click
    wait_for_ajax
    expect(get_current_payment_gateway == 'Webmoney').to be true
    expect(get_commission_gateway > 0).to be true
    expect(get_current_bill - 1 == init_bill).to be true
  end

  it 'change type payment gateway to offline gateway' do
    init_bill = get_current_bill
    open_order_tools_tab
    select('Терминал', from: 'switch_payment_gateway[id]')
    find('[value="Изменить"]').click
    wait_for_ajax
    puts get_current_payment_gateway
    expect(get_current_payment_gateway =='Терминал').to be true
    expect(get_commission_gateway == 0).to be true
    expect(get_current_bill - 1 == init_bill).to be true
  end

  it 'reissue tickets' do
    fill_booking_fares
    fill_passengers_tickets
    update_avia_tickets
    wait_for_ajax
    find('[value="Отправить билет"]').click
    wait_for_ajax
    expect(page).to have_content('Билет впервые выписан')
  end

  it 'increase fare and reissue new bill' do
    init_bill = get_current_bill
    init_order_amount = get_order_amount
    fare_passenger_elem = first('[id*="passengers_attributes_0_fare"]')
    fare_to_increase = 100
    increase_fare(fare_passenger_elem, fare_to_increase)
    find('[value="Выставить новый счет"]').click
    wait_for_ajax
    expect(page).not_to have_selector('[value="Выставить новый счет"]')
    # check that order amount increased
    expect(init_order_amount + fare_to_increase == get_order_amount).to be true
    # check that bill increased
    expect(init_bill + 1 == get_current_bill).to be true
  end
end

