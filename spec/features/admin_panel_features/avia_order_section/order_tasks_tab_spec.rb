require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/avia_order_service_helper'
require 'support/ajax_waiter'

describe 'Tests for order in admin panel' do
  include AdminOrderService
  include AdminAuthHelper
  include WaitForAjax

  r = Random.new

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    open_round_trip_order_in_admin
  end

  it 'create task, change status, remove it' do
    open_tasks_tab
    # generate unique task message
    task = "TASK DESCRIPTION #{r.rand(100...1000)}"
    find('#admin_task_description').set task
    # create task
    find('[value="Создать"]').click
    expect(page).to have_content(task)
    # click on edit task button
    first('[id*="row_admin_task"] .fa-edit').click
    # change status on "В работе"
    select('В работе', from: 'admin_task[status]')
    find('[value="Обновить"]').click
    expect(page).to have_content('В работе')
  end
end