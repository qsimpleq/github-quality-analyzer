# frozen_string_literal: true

class RenameStateToAasmState < ActiveRecord::Migration[7.0]
  def change
    rename_column :repository_checks, :state, :aasm_state
  end

  def down
    rename_column :repository_checks, :aasm_state, :state
  end
end
