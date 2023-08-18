# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  state         :string           default("created"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  repository_id :integer          not null
#
# Indexes
#
#  index_repository_checks_on_repository_id  (repository_id)
#  index_repository_checks_on_state          (state)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository
  class Check < ApplicationRecord
    include AASM

    belongs_to :repository, inverse_of: :checks

    aasm(column: 'state') do
      state :created, initial: true
      state :fetching,
            :fetched,
            :checking,
            :checked,
            :finished,
            :failed

      event :fetch do
        transitions from: :created, to: :fetching
      end

      event :is_fetched do
        transitions from: :fetching, to: :fetched
      end

      event :check do
        transitions from: :fetched, to: :checking
      end

      event :is_checked do
        transitions from: :checking, to: :checked
      end

      event :finish do
        transitions from: :checked, to: :finished
      end

      event :failed do
        transitions from: %i[fetching checking checked], to: :failed
      end
    end
  end
end
