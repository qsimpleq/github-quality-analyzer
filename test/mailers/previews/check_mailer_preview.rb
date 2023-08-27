# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/check_mailer
class CheckMailerPreview < ActionMailer::Preview
  def lint_with_offenses
    CheckMailer.with(
      check: Repository::Check.where(state: :finished, check_passed: false).first,
      error: "Wrong linter parameters\n\nExit code: 12\n\n"
    ).lint_with_offenses
  end

  def lint_failed
    CheckMailer.with(
      check: Repository::Check.where(state: :failed, check_passed: false).first
    ).lint_failed
  end
end
