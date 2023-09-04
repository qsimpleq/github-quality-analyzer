# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/check_mailer
class CheckMailerPreview < ActionMailer::Preview
  def check_with_offenses
    CheckMailer.with(
      check: Repository::Check.where(aasm_state: :finished, passed: false).first,
      error: "Wrong linter parameters\n\nExit code: 12\n\n"
    ).check_with_offenses
  end

  def check_failed
    CheckMailer.with(
      check: Repository::Check.where(aasm_state: :failed, passed: false).first
    ).check_failed
  end
end
