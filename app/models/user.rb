# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true
  validates :nickname, presence: false
  validates :token, presence: false
end
