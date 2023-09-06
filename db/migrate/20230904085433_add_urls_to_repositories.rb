# frozen_string_literal: true

class AddUrlsToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :git_url, :string
    add_column :repositories, :ssh_url, :string

    # rubocop:disable Rails/SkipsModelValidations
    Repository.update_all("git_url = 'https://github.com/' || full_name WHERE git_url IS NULL")
    Repository.update_all("ssh_url = 'git@github.com:' || full_name || '.git' WHERE ssh_url IS NULL")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    remove_column :repositories, :git_url
    remove_column :repositories, :ssh_url
  end
end
