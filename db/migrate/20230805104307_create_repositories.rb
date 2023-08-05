# frozen_string_literal: true

class CreateRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :language
      t.datetime :repo_created_at
      t.datetime :repo_updated_at

      t.timestamps
    end
  end
end
