# frozen_string_literal: true

class RenameCheckPassedToPassed < ActiveRecord::Migration[7.0]
  def change
    rename_column :repository_checks, :check_passed, :passed
  end

  def down
    rename_column :repository_checks, :passed, :check_passed
  end
end
