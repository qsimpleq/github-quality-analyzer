# frozen_string_literal: true

module FlashDecorator
  def self.included(base)
    base.class_eval do
      alias_method :original_flash_assign, :[]=
      alias_method :[]=, :decorated_flash_assign
    end
  end

  def decorated_flash_assign(key, value)
    k = key.to_sym
    if k == :notice
      original_flash_assign(:info, value)
    elsif k.in?(%i[alert error])
      original_flash_assign(:danger, value)
    else
      original_flash_assign(key, value)
    end
  end
end
