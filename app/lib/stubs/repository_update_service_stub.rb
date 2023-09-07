# frozen_string_literal: true

module Stubs
  class RepositoryUpdateServiceStub < RepositoryUpdateService
    include Stubs
    attr_reader :language

    def initialize(repository)
      super
      @language = @repository.language
      @repo_info = Stubs::REPOSITORY["#{@language.downcase}_repo_info_path".to_sym]
    end

    def perform
      data = load_json_fixture(@repo_info)
      @repository.update(build_update_data(data))
    end
  end
end
