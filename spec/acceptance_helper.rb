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

  def authenticate_to_admin!
    authenticate("habitat", "iloveyou")
  end

  def authenticate_to_member!
    visit("/users/sign_in")
    fill_in 'user_phone_number', :with => '01011112222'

    click_button "전화번호로 로그인"
  end
end