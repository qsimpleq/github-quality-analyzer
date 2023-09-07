# frozen_string_literal: true

class FetchRepositoriesJob < ApplicationJob
  queue_as :default

  def perform(user)
    ApplicationContainer[:fetch_repositories_service].new(user).perform
  end
end
