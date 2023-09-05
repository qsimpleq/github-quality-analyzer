# frozen_string_literal: true

class ApplicationService
  include AnyClients

  def current_user(user = nil)
    @current_user ||= user
  end
end
