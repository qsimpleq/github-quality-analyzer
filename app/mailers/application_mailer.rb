# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  include ApplicationHelper
  default from: "#{Rails.application.class.module_parent_name}@example.com"

  layout 'mailer'
end
