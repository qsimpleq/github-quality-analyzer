# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  check_passed  :boolean          default(FALSE)
#  check_result  :json
#  offense_count :integer
#  state         :string           default("created"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  commit_id     :string
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
            :linting,
            :linted,
            :parsing,
            :parsed,
            :finished,
            :failed

      event :fetch do
        transitions from: :created, to: :fetching
      end

      event :is_fetched do
        transitions from: :fetching, to: :fetched
      end

      event :lint do
        transitions from: :fetched, to: :linting
      end

      event :is_linted do
        transitions from: :linting, to: :linted
      end

      event :parse do
        transitions from: :linted, to: :parsing
      end

      event :is_parsed do
        transitions from: :parsing, to: :parsed
      end

      event :finish do
        transitions from: :parsed, to: :finished
      end

      event :failed do
        transitions from: %i[fetching linting checked parsing parsed], to: :failed
      end
    end
  end
end