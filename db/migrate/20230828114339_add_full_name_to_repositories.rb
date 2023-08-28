# frozen_string_literal: true

class AddFullNameToRepositories < ActiveRecord::Migration[7.0]
  def change
    add_column :repositories, :full_name, :string

    Repository.find_each { |repo| repo.update(full_name: "#{repo.user.nickname}/#{repo.name}") }
  end

  def down
    remove_column :repositories, :full_name
  end
end
