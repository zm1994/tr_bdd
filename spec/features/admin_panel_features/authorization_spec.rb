require 'rails_helper'
require 'support/admin_support/auth_helper'
require 'support/admin_support/root_path_helper'

describe 'Authorization in admin panel' do
  include AdminAuthHelper

  admin_email = ''
  content_email = ''
  booker_email = ''
  analyst_email = ''
  first_line_email = ''
  second_line_email = ''
  password = 'password'

  before(:all) do
    admin_email = generate_random_email
    content_email = generate_random_email
    booker_email = generate_random_email
    analyst_email = generate_random_email
    first_line_email = generate_random_email
    second_line_email = generate_random_email
  end

  before do
    visit($root_path_admin)
  end

  it 'checks delineation of rights for admin ' do
    log_in_admin_panel($email_admin, $password_admin)
    visit($path_new_admin)
    create_admin_user(admin_email, password, :admin)

    expect(page).to have_selector('#заявки')
    expect(page).to have_selector('#контент')

    expect(page).to have_selector('#пользователи')
    expect(page).to have_selector('a', text: "Доп. настройки")
    expect(page).to have_selector('#статистика')
    expect(page).to have_selector('#api')
    expect(page).to have_selector('#amadeus')
  end

  it 'checks delineation of rights for booker' do
    # create user
    log_in_admin_panel($email_admin, $password_admin)
    visit($path_new_admin)
    create_admin_user(booker_email, password, :booker)

    expect(page).to have_selector('#заявки')
    expect(page).to have_selector('#статистика')
    expect(all('#tabs li').count == 3).to be true
  end

  it 'checks delineation of rights for analyst' do
    # create user
    log_in_admin_panel($email_admin, $password_admin)
    visit($path_new_admin)
    create_admin_user(analyst_email, password, :analyst)

    expect(page).to have_selector('#заявки')
    expect(page).to have_selector('a', text: "Доп. настройки")
    expect(page).to have_selector('#статистика')
    expect(all('#tabs li').count == 4).to be true
  end

  it 'checks delineation of rights for first line' do
    # create user
    log_in_admin_panel($email_admin, $password_admin)
    visit($path_new_admin)
    create_admin_user(first_line_email, password, :first_line)

    # pry.binding
    expect(page).to have_selector('#заявки')
    expect(page).to have_selector('#пользователи')
    expect(all('#tabs li').count == 3).to be true
  end

  it 'checks delineation of rights for second line' do
    # create user
    log_in_admin_panel($email_admin, $password_admin)
    visit($path_new_admin)
    create_admin_user(second_line_email, password, :second_line)

    expect(page).to have_selector('#заявки')
    expect(page).to have_selector('#пользователи')
    expect(page).to have_selector('a', text: "Доп. настройки")
    expect(all('#tabs li').count == 4).to be true
  end

  it 'checks delineation of rights for content' do
    # create user
    log_in_admin_panel($email_admin, $password_admin)
    visit($path_new_admin)
    create_admin_user(content_email, password, :content)

    expect(page).to have_selector('#контент')
    expect(page).to have_selector('#контакты')
    expect(all('#tabs li').count == 3).to be true
  end
end