# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_checks
#
#  id            :integer          not null, primary key
#  aasm_state    :string           default("created"), not null
#  check_passed  :boolean          default(FALSE)
#  check_result  :json
#  offense_count :integer
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
    test '#fetch!' do
      assert repository_checks(:created).fetch!
    end

    test '#is_fetched!' do
      assert repository_checks(:fetching).is_fetched!
    end

    test '#lint!' do
      assert repository_checks(:fetched).lint!
    end

    test '#is_linted!' do
      assert repository_checks(:linting).is_linted!
    end

    test '#parse!' do
      assert repository_checks(:linted).parse!
    end

    test '#finish!' do
      assert repository_checks(:parsed).finish!
    end

    test '#failed!' do
      assert repository_checks(:fetching).failed
      assert repository_checks(:fetched).failed!
      assert repository_checks(:linting).failed!
      assert repository_checks(:linted).failed!
      assert repository_checks(:parsed).failed!
    end
  end
end
