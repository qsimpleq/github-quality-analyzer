# frozen_string_literal: true

module Stubs
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
