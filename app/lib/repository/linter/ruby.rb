# frozen_string_literal: true

class Repository
  class Linter
    class Ruby
      attr_accessor :repository,
                    :result,
                    :stdout,
                    :stderr,
                    :status

      def initialize(repository)
        @repository = repository
      end

      def run
        lint_options = [
          select_config,
          '--safe',
          '--lint',
          '--ignore-unrecognized-cops',
          '--force-default-config',
          "--format json #{@repository.directory}"
        ]

        command = "bundle exec rubocop #{lint_options.join(' ')}"
      ensure
        begin
          @stdout, @stderr, @status = Open3.capture3(command)
          JSON.parse(@stdout, symbolize_names: true)
        rescue StandardError
          { status: @status, error: @stderr }
        end
      end

      private

      def select_config
        repository_config = "#{@repository.directory}/.rubocop.yml"
        if File.exist?(repository_config)
          "--config #{repository_config}"
        else
          '--force-default-config'
        end
      end
    end
  end
end
