module OrderHelper


  def find_order_in_admin(order_name)
    find('a', text: order_name).click
    expect(page).to have_content(order_name)
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
    find('#order_owner_bonus_account tbody>tr:last-of-type() .align-right').text.split(' ').first.to_f
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
end