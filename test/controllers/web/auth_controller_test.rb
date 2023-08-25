# frozen_string_literal: true

require 'test_helper'

module Web
  class AuthControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user1 = users(:user1)
    end

    test '#request' do
      post auth_request_path('github')

      assert_response :redirect
    end

    test '#callback' do
      sign_in(@user1)

      assert_redirected_to root_path
      assert User.find(@user1.id)
      assert { signed_in? }
      assert_equal flash[:notice], t('.sign_in')
    end

    test '#destroy' do
      delete auth_logout_path

      assert_response :redirect
      assert_equal flash[:notice], t('.sign_out')
    end
  end
end
