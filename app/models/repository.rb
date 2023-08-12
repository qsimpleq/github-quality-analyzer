# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id              :integer          not null, primary key
#  language        :string
#  name            :string
#  repo_created_at :datetime
#  repo_updated_at :datetime
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
class Repository < ApplicationRecord
  extend Enumerize
  belongs_to :user, inverse_of: :repositories
  validates :github_id, presence: true

  enumerize :language,
            default: :javascript,
            in: %i[javascript ruby]
end
