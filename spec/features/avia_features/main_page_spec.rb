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

  it'check following a facebook tripway' do
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

  it'check following a google+ tripway', js:true do
    find('.footer_top__social_link-google_plus').click
    within_window(page.driver.browser.window_handles.last) do
      expect(page.current_url == 'https://plus.google.com/+Tripway').to be true
      # puts page.current_url
    end
  end

  it'check following all footer links tripway', js:true do
    # # доделать!!!!!!!
    # footer = find('#footer')
    # # pry.binding
    # pry.bindig
    # arr = footer.all('li a').map {|a| a['href']}.to_a
    # # pry.binding
    # footer.all(:link, "a").each do |link|
    #   link.click
    #   # page.driver.browser.switch_to.alert.accept
    #   expect(page_broken?).to be false
    #   unless page.has_css?('#footer')
    #     visit($root_path_avia)
    #   end
    # end
  end
end

