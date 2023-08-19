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
require 'test_helper'

class Repository
  class CheckTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
