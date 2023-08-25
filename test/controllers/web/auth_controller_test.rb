# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user1 = users(:user1)
    end

    test 'should github auth' do
      post auth_request_path('github')

      assert_response :redirect
    end

    test 'create' do
      auth_hash = {
        info: {
          email: @user1.email,
          nickname: @user1.nickname
        },
        credentials: {
          token: 'fake'
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_path('github')

      assert_response :redirect

      user = User.find_by!(email: auth_hash[:info][:email].downcase)

      assert user
      assert { signed_in? }
    end

    test 'should destroy' do
      delete auth_logout_path

      assert_response :redirect
    end
  end
end
