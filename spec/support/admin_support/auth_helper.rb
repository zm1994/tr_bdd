module AdminAuthHelper

  # this is admin login and passw for entry in admin panel


  def log_in_admin_panel(email, password)
    find('input#admin_user_email').set email
    find('input#admin_user_password').set password
    find('[type="submit"]').click

    expect(page).to have_selector('.logged_in.cockpit_namespace')
  end

  def create_admin_user(email, password, type_user)
    find('input#admin_user_email').set email
    find('input#admin_user_full_name').set 'Test Test'
    find('input#admin_user_password').set password
    find('input#admin_user_password_confirmation').set password

    # choose admin role
    find('#admin_user_role').click
    case
      when type_user.equal?(:admin)
        select('Супер администратор', from: 'admin_user_role')
      when type_user.equal?(:content)
        select('Контент менеджер', from: 'admin_user_role')
      when type_user.equal?(:analyst)
        select('Аналитик', from: 'admin_user_role')
      when type_user.equal?(:booker)
        select('Бухгалтер', from: 'admin_user_role')
      when type_user.equal?(:first_line)
        select('1 линия поддержки', from: 'admin_user_role')
      when type_user.equal?(:second_line)
        select('2 линия поддержки', from: 'admin_user_role')
    end

    #click save user admin
    find('[name="commit"]').click

    # expect created user
    expect(page).to have_selector('.attributes_table.admin_user')

    #logout and login in new user
    logout_from_admin_panel
    log_in_admin_panel(email, password)
  end

  def generate_random_email
    randon_number = Random.new
    email = 'test' + randon_number.rand(1000...50000).to_s + '@example.com'
  end

  def logout_from_admin_panel
    find('#logout a').click
    expect(page).to have_selector('#active_admin_content')
  end
end