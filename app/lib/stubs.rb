# frozen_string_literal: true

module Stubs
  REPOSITORY = {
    commit_id: '9340a54',
    javascript_lint_path: Rails.root.join('test/fixtures/files/javascript_lint.json'),
    javascript_repo_info_path: Rails.root.join('test/fixtures/files/javascript_repo_info.json'),
    octokit_repositories_path: Rails.root.join('test/fixtures/files/octokit_repositories.json'),
    ruby_lint_path: Rails.root.join('test/fixtures/files/ruby_lint.json'),
    ruby_repo_info_path: Rails.root.join('test/fixtures/files/ruby_repo_info.json')
  }.freeze

  private

  def load_json_fixture(path)
    file_name = File.basename(path, '.json')
    instance_variable_name = "@#{file_name}"

    unless instance_variable_get(instance_variable_name)
      instance_variable_set(instance_variable_name, JSON.parse(File.read(path), symbolize_names: true))
    end

    instance_variable_get(instance_variable_name)
  end

  def load_fixture(*)
    File.read(File.join(*))
  end
end
