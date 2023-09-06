# frozen_string_literal: true

class AddProviderAndUidToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string

    # rubocop:disable Rails/SkipsModelValidations
    User.update_all("provider = 'github' WHERE provider IS NULL")
    # rubocop:enable Rails/SkipsModelValidations
  end

  def down
    remove_column :users, :uid
    remove_column :users, :provider
  end
end
