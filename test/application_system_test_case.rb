# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  WebMock.allow_net_connect!

  # driven_by :selenium, using: :chrome, screen_size: [1920, 1080]
  driven_by :selenium, using: :headless_chrome

  def sign_in(user, _options = {})
    mock_omniauth(user)
    visit callback_auth_url('github')
  end
end
