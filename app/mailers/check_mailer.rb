# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def lint_failed
    linter_mail
  end

  def lint_with_offenses
    linter_mail
  end

  private

  def linter_mail
    @check = params[:check]
    @error = params[:error]
    @repository = @check.repository
    @user = @repository.user
    @repository_check_url = repository_check_url(@repository,
                                                 @check,
                                                 host: RailsProject66::Application::DEFAULT_HOST_URL)

    mail(to: @user.email, subject: t('.subject', repo_name: @repository.full_name))
  end
end
