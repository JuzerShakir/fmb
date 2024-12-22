module SignInHelper
  def sign_in(user)
    visit login_path
    fill_in "sessions_its", with: user.its
    fill_in "sessions_password", with: user.password
    # Check if JS is enabled or disabled in test
    if Capybara.current_driver == Capybara.javascript_driver
      # Use JavaScript to click on login
      page.execute_script("arguments[0].click();", find('input[name="commit"]'))
      sleep 0.03
    else
      # W/O JavaScript
      click_on "Login"
    end
  end
end
