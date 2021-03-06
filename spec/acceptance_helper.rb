module AcceptanceHelper
  def authenticate(name, password)
    if page.driver.respond_to?(:basic_auth)
      page.driver.basic_auth(name, password)
    elsif page.driver.respond_to?(:basic_authorize)
      page.driver.basic_authorize(name, password)
    elsif page.driver.respond_to?(:browser) and page.driver.browser.respond_to?(:basic_authorize)
      page.driver.browser.basic_authorize(name, password)
    else
      raise "I don't know how to log in!"
    end
  end

  def authenticate_to_admin!(admin_user)
    login_as(admin_user, scope: :admin_user)
  end

  def authenticate_user!(user)
    visit(club_sign_in_path(user.club, user))
    fill_in 'user_phone_number', :with => user.phone_number

    click_button "전화번호로 로그인"
  end
end