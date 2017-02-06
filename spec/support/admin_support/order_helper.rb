module OrderHelper

  def find_order_in_admin(order_name)
    find('a', text: order_name).click
    expect(page).to have_content(order_name)
  end

  def open_order_tab
    find('[href="#order"]').click
  end

  def open_order_items_tab
    find('[href="#order_items_tab"]').click
  end

  def open_order_payer_tab
    find('[href="#order_payer_tab"]').click
  end

  def open_order_owner_tab
    find('[href="#order_owner_tab"]').click
  end

  def open_order_tools_tab
    find('[href="#order_tools_tab"]').click
  end

  def open_incomes_tab
    find('[href="#incomes"]').click
  end

  def open_tasks_tab
    find('[href="#tasks"]').click
  end

  def open_bills_tab
    find('[href="#bills"]').click
  end

  def open_claims_tab
    find('[href="#claims"]').click
  end

  def fill_booking_fares
    # click all avia booking tabs in order
    all('[href*="#avia_amadeus_booking"]').each do |avia_booking|
      avia_booking.click
      # set PNR
      find('[id*="airline_pnr"]').set 'TESTPNR'
      # set fare foods for passengers
      all('.avia_journey_bookings_sections_variants_flights_fares_food select').select do |item|
        select('BREAKFAST', from: item['name'])
      end
      # set fare baggage for passengers
      all('.avia_journey_bookings_sections_variants_flights_fares_baggage select').select do |item|
        select('1', from: item['name'])
      end
    end
  end

  def fill_passengers_tickets
    all('.avia_journey_bookings_passengers_ticket input').each do |item|
      item.set '123-12433254324'
    end
  end

  def update_avia_tickets
    find('[value="Обновить данные авиабилетов"]').click
  end

  def get_order_bonuse_amount
    find('#order_owner_bonus_account tbody tr.odd .align-right').text.split(' ').first.to_f
  end

  def get_order_amount
    find('#order_items_tab tbody tr:nth-of-type(4) td:nth-of-type(8)').text.split(' ').first.to_f
  end

  def get_subagent_reward
    find('#order_items_tab tbody tr:nth-of-type(4) td:nth-of-type(7)').text.split(' ').first.to_f
  end

  def get_order_status
    find('.status_tag').text
  end

  def get_current_bill
    open_bills_tab
    cur_bill = first('#bills .index_table tbody tr td:nth-of-type(1)').text.to_f
    open_order_tab
    cur_bill
  end

  def get_current_payment_gateway
    open_bills_tab
    cur_gateway = first('#bills .index_table td:nth-of-type(4)').text
    open_order_tab
    cur_gateway
  end

  def get_commission_gateway
    open_bills_tab
    commission = find('#bills .index_table td:nth-of-type(7)').text.split(' ').first.to_f
    open_order_tab
    commission
  end

  def set_payment(amount_to_pay, payment_gateway, deduct_gateway_fee = true)
    find('#order_bill_payment_form_amount').set amount_to_pay
    select(payment_gateway, from: 'order_bill_payment_form[gateway_id]')
    find('#order_bill_payment_form_deduct_gateway_fee').click if deduct_gateway_fee
    find('[value="Внести оплату"]').click
  end

  def get_paid_amount
    open_bills_tab
    cur_gateway = first('#bills .index_table td:nth-of-type(10)').text.split(' ').first.to_f
    open_order_tab
    cur_gateway
  end

  def get_amount_to_pay
    open_bills_tab
    cur_gateway = first('#bills .index_table td:nth-of-type(8)').text.split(' ').first.to_f
    open_order_tab
    cur_gateway
  end

  def increase_fare(input_element, amount_increase)
    # increase current value input element on amount
    input_element.set  input_element.value.to_f + amount_increase
    update_avia_tickets
    wait_for_ajax
    increased_amount = find('#order_items_tab tbody tr:nth-of-type(1) td:nth-of-type(9)').text.split(' ').first.to_f
    expect(increased_amount == amount_increase).to be true
  end

  def decrease_fare(input_element, amount_decrease)
    # decrease current value input element on amount
    input_element.set  input_element.value.to_f - amount_decrease
    update_avia_tickets
    wait_for_ajax
    decreased_amount = find('#order_items_tab tbody tr:nth-of-type(1) td:nth-of-type(9)').text.split(' ').first.to_f
    expect(decreased_amount == amount_decrease).to be true
  end

  def order_paid_in_full?
    # check that amount to pay is 0
    get_amount_to_pay == 0
  end
end