def page_broken?
  return page.has_css?('.error-page-404') or page.has_css?('.error-page-500')
end