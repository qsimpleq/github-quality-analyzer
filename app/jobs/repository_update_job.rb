# frozen_string_literal: true

class RepositoryUpdateJob < ApplicationJob
  queue_as :default

  def perform(repository)
    ApplicationContainer[:repository_update_service].new(repository).perform
  end
end
