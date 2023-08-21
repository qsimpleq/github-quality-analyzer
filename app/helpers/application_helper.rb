# frozen_string_literal: true

module ApplicationHelper
  def repo_url(repository)
    "https://github.com/#{current_user.nickname}/#{repository.name}"
  end
end
