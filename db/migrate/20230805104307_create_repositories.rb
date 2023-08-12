# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.integer :github_id, index: true
      t.string :name, index: true
      t.string :language, index: true
      t.datetime :repo_created_at
      t.datetime :repo_updated_at
      t.references :user, index: true

      t.timestamps
    end
  end
end
