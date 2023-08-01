# frozen_string_literal: true

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user_one = users(:one)
    end

    test 'should github auth' do
      post auth_request_path('github')

      assert_response :redirect
    end

    test 'create' do
      auth_hash = {
        info: {
          email: @user_one.email,
          nickname: @user_one.nickname
        },
        credentials: {
          token: 'fake'
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

      get callback_auth_url('github')

      assert_response :redirect

      user = User.find_by!(email: auth_hash[:info][:email].downcase)

      assert user
      assert_predicate self, :signed_in?
    end

    test 'should destroy' do
      delete auth_logout_url

      assert_response :redirect
    end
  end
end
