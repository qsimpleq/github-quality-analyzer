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
require 'test_helper'

class Repository
  class CheckTest < ActiveSupport::TestCase
    test '#run_check!' do
      assert repository_checks(:created).run_check!
    end

    test '#mark_as_finish!' do
      assert repository_checks(:checking).mark_as_finish!
    end

    test '#mark_as_fail!' do
      assert repository_checks(:checking).mark_as_fail!
    end
  end
end
