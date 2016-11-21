require 'rails_helper'
require 'support/root_path_helper'
require 'support/page_helper'

describe 'Main page' do
  before do
    visit($root_path_avia)
  end
  it'check following a link Booking.com' do
    find('.header_menu__link[title="Отели"]').click
    # check link to tripway site in new opened tab
    check_booking_link
  end

  it'check following a link blog tripway' do
    find('.header_menu__link[title="Блог"]').click
    check_blog_link
  end

  it'check following a facebook tripway' do
    find('.footer_top__social_link-facebook').click
    within_window(page.driver.browser.window_handles.last) do

      expect(page.current_url == 'https://www.facebook.com/tripwaycom').to be true
      puts page.current_url
    end
  end

  it'check following a instagram tripway' do
    find('.footer_top__social_link-instagram').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://www.instagram.com/tripwaycom/').to be true
    end
  end

  it'check following a vk tripway' do
    find('.footer_top__social_link-vk').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://vk.com/tripway').to be true
    end
  end

  it'check following a google+ tripway' do
    find('.footer_top__social_link-google_plus').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://plus.google.com/+Tripway').to be true
    end
  end
end

