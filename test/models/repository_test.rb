# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  full_name       :string
#  git_url         :string
#  language        :string
#  name            :string
#  repo_created_at :datetime
#  repo_updated_at :datetime
#  ssh_url         :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  github_id       :integer
#  user_id         :integer
#
# Indexes
#
#  index_repositories_on_github_id  (github_id)
#  index_repositories_on_language   (language)
#  index_repositories_on_name       (name)
#  index_repositories_on_user_id    (user_id)
#
require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
