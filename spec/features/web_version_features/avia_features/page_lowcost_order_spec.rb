# require 'rails_helper'
# require 'support/auth_helper'
# require 'support/root_path_helper'
# require 'support/avia_booking_helper'
# require 'support/avia_search_helper'
# require 'support/avia_test_data_helper'
# require 'support/avia_booking_service_helper'
#
# describe 'Page avia order for round search' do
#   include AviaSearch
#   include AviaBooking
#   include AuthHelper
#   include AviaBookingService
#
#   before do
#     visit($root_path_avia)
#     unless ($url_page_booking_round_lowcost.empty?)
#       visit($url_page_booking_round_lowcost)
#     else
#       open_boking_page_round_lowcost
#     end
#   end
#
#   it 'check availability to autorization and choose first passenger passenger usual user in lowcost', retry: 3 do
#     auth_from_booking_page('test@example.com', 'qwerty123')
#     # click and check first passenger from dropdown list
#     expect(page).to have_selector('.avia_kiwi_order_form')
#     first('[data-class="Avia.PassengersDropdown"]').click
#     first('.order_form_passengers_dropdown__menu_item').click
#     expect(first('.avia_kiwi_order_journey_item_element_documents_firstname input').value.empty?).to be(false)
#   end
#
#   it'check choice baggage in lowcost order page', retry: 3 do
#     # click button choose baggage
#
#     first('.order_form__add_baggage_button').click
#     # choose 1 baggage
#     first('[for="avia_kiwi_order_journey_item_attributes_element_attributes_documents_attributes_0_additional_baggage_quantity_1"]').click
#     expect(page).to have_selector('.notify_message_layout-modal_dialog')
#     find('[data-role="avia.kiwi.orders.error_message.continue"]').click
#     expect(page).not_to have_selector('.notify_message_layout-modal_dialog')
#   end
# end
