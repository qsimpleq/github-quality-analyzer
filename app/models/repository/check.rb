# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string           default("created"), not null
#  check_result  :json
#  offense_count :integer
#  passed        :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  commit_id     :string
#  repository_id :integer          not null
#
# Indexes
#
#  index_repository_checks_on_aasm_state     (aasm_state)
#  index_repository_checks_on_repository_id  (repository_id)
#
# Foreign Keys
#
#  repository_id  (repository_id => repositories.id)
#
class Repository
  class Check < ApplicationRecord
    include AASM

    belongs_to :repository, inverse_of: :checks

    aasm do
      state :created, initial: true
      state :checking, :finished, :failed

      event :run_check do
        transitions from: :created, to: :checking
      end

      event :mark_as_finish do
        transitions from: :checking, to: :finished
      end

      event :mark_as_fail do
        transitions from: :checking, to: :failed
      end
    end

    def in_process?
      !finished? && !failed?
    end
  end
end
