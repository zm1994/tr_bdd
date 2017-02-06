module ClaimService
  def open_claim_page
    find('.order__claims_link').click
    expect(page).to have_selector('.column_width-narrow')
  end

  def send_claim(message)
    find('.column_width-wide>div.active textarea.input').set message
    find('.column_width-wide>div.active [type="submit"]').click
    if(page.has_css?('.confirmation_message__action_link_layout-modal_dialog'))
      find('[data-confirmation-action="confirm"]').click
    end
    expect(page).to have_selector('.notify_message')
    find('.notify_message__action_link').click
    chat_area = find('.column_width-wide>div.active .order_claim_messages')
    expect(chat_area).to have_content(message)
  end
end