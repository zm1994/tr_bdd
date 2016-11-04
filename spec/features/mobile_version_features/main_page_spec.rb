require 'rails_helper'
require 'support/firefox_driver'
require 'support/page_helper'


describe 'Mobile main page' do
  before do
    visit($root_path_mobile_avia)
    find('.mobile_header_action__select-menu').click
    expect(page).to have_selector('.hamburger__items')
  end

  it 'check in hamburger menu link to avia main page' do
    puts $root_path_mobile_avia
    find('.hamburger__link-avia_tickets').click
    # find form for search avia trips
    expect(page).to have_selector('.avia_search_form__theme-mobile_homepage')
  end

  it 'check in hamburger menu link to railway main page' do
    find('.hamburger__link-railway_tickets').click
    # find form for search railway trips
    expect(page).to have_selector('.railway_search_form__wrapper_theme-homepage')
  end

  it 'check in hamburger menu link to booking page' do
    find('.hamburger__link-hotels').click
    check_booking_link
  end

  it 'check in hamburger menu link to blog page' do
    find('.hamburger__link-blog').click
    check_blog_link
  end
end