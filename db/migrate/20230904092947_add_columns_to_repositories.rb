# frozen_string_literal: true

class AddColumnsToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string

    User.where(provider: nil).find_each { |user| user.update(provider: 'github') }
  end

  def down
    remove_column :users, :uid
    remove_column :users, :provider
  end
end
