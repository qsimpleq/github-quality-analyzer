# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    {
      notice: 'alert-info',
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-danger'
    }.fetch(level.to_sym, '')
  end
end
