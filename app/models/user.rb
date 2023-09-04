# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string
#  nickname   :string
#  provider   :string
#  token      :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_many :repositories, inverse_of: :user, dependent: :nullify
  validates :email, presence: true
  validates :nickname, presence: false
  validates :token, presence: false
  validates :provider,
            presence: true,
            uniqueness: { scope: [:uid] },
            inclusion: { in: %w[github] }
  validates :uid, presence: true
end
