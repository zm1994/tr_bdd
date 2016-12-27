module OrderHelper
  def find_order_in_admin(order_name)
    find('a', text: order_name).click
    expect(page).to have_content(order_name)
  end
end