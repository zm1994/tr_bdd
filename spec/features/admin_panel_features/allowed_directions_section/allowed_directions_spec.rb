require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'
require 'support/admin_support/additional_configurations_helpers/allowed_directions_helper'

describe 'Admin panel tests for cities in admin' do
  include AdminAuthHelper
  include AllowedDirection

  before do
    visit($root_path_admin)
    log_in_admin_panel($email_admin, $password_admin)
    visit($root_path_admin + 'avia_api_allowed_directions')
  end

  it 'create direction IEV-MIL' do
    delete_direction('IEV', 'MIL')
    delete_direction('MIL','IEV')
    visit($root_path_admin + 'avia_api_allowed_directions/new')
    create_direction('IEV', 'MIL')
    expect(page).not_to have_content('уже существует')
    expect(page).to have_content('successfully created')
  end

  it 'create direction MIL-IEV on existed direction IEV-MIL' do
    delete_direction('IEV', 'MIL')
    delete_direction('MIL','IEV')
    visit($root_path_admin + 'avia_api_allowed_directions/new')
    create_direction('IEV', 'MIL')
    expect(page).to have_content('successfully created')
    # create same allowed direction with difference on departure and arrival code
    visit($root_path_admin + 'avia_api_allowed_directions/new')
    create_direction('MIL', 'IEV')
    expect(page).to have_selector('.errors')
  end
end