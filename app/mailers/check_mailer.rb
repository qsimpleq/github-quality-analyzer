# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def check_failed
    check_mail
  end

  def check_with_offenses
    check_mail
  end

  private

  def check_mail
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
