require 'rails_helper'
require 'support/firefox_driver'
require 'support/page_helper'

describe 'Main page' do
  before do
    visit($root_path_avia)
  end
  it'check following a link Booking.com' do
    find('.header_menu__link[title="Отели"]').click
    # check link to tripway site in new opened tab
    within_window(page.driver.browser.window_handles.last) do
      expect(page).to have_selector('.aff--cobrand_header_wrapper')
      expect(page).to have_selector('[href="http://	www.tripway.com"]')
    end
  end

  it'check following a link blog tripway' do
    find('.header_menu__link[title="Блог"]').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://tripway.com/blog/').to be true
    end
  end

  it'check following a facebook tripway', js:true do
    find('.footer_top__social_link-facebook').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://www.facebook.com/tripwaycom').to be true
      puts page.current_url
    end
  end

  it'check following a twitter tripway' do
    find('.footer_top__social_link-twitter').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://twitter.com/tripway').to be true
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

  # it'check following a google+ tripway', js:true do
  #   visit('https://tripway.dev/500')
  #   pry.binding
  #   # expect(page_broken?).to be true
  # end
end
