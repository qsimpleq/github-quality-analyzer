# frozen_string_literal: true

class CreateRepositoryChecks < ActiveRecord::Migration[7.0]
  def change
    create_table :repository_checks do |t|
      t.references :repository, null: false, foreign_key: true
      t.string :state, null: false, default: 'created'

      t.timestamps
    end
    add_index :repository_checks, :state
  end
end
