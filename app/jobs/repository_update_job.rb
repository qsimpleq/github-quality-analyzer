# frozen_string_literal: true

class RepositoryUpdateJob < ApplicationJob
  queue_as :default

  def perform(repository)
    RepositoryUpdateService.new(repository).perform
  end
end
