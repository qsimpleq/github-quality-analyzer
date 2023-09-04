# frozen_string_literal: true

class RemoveIndexesFromRepositories < ActiveRecord::Migration[7.0]
  def up
    remove_index :repositories, column: :github_id, name: 'index_repositories_on_github_id', if_exists: true
    remove_index :repositories, column: :language, name: 'index_repositories_on_language', if_exists: true
    remove_index :repositories, column: :name, name: 'index_repositories_on_name', if_exists: true
  end

  def down
    add_index :repositories, :github_id, if_not_exists: true
    add_index :repositories, :language, if_not_exists: true
    add_index :repositories, :name, if_not_exists: true
  end
end
