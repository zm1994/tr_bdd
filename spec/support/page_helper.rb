def page_broken?
  return page.has_css?('.error-page-500') || page.has_css?('.error-page-404')
end