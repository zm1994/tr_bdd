def page_broken?
  return page.has_css?('.error-page-500') || page.has_css?('.error-page-404')
end

def check_booking_link
  within_window(page.driver.browser.window_handles.last) do
    expect(page).to have_selector('.aff--cobrand_header_wrapper')
    expect(page).to have_selector('[href="http://	www.tripway.com"]')
  end
end

def check_blog_link
  within_window(page.driver.browser.window_handles.last) do
    expect(page.current_url == 'https://tripway.com/blog/').to be true
  end
end


