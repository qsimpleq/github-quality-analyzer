# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository)
    ApplicationContainer[:repository_check_service].new.perform(repository)
  end
end
