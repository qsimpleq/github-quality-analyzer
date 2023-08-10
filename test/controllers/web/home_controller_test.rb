# frozen_string_literal: true

require 'test_helper'

module Web
  class HomeControllerTest < ActionDispatch::IntegrationTest
    test '#show' do
      get root_url

      assert_response :success
    end
  end
end
