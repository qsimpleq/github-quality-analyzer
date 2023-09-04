# frozen_string_literal: true

class AddFieldsToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :git_url, :string
    add_column :repositories, :ssh_url, :string

    Repository.where(git_url: nil).find_each do |repo|
      repo.update(
        git_url: "https://github.com/#{repo.full_name}",
        ssh_url: "git@github.com:#{repo.full_name}.git"
      )
    end
  end

  def down
    remove_column :repositories, :git_url
    remove_column :repositories, :ssh_url
  end
end
