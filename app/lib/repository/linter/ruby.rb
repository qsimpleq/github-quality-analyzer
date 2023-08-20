# frozen_string_literal: true

class Repository
  class Linter
    class Ruby
      attr_reader :repository, :json_result, :result, :offense_count

      def initialize(repository)
        @repository = repository
      end

      def run
        lint_options = [
          select_config,
          '--safe',
          '--ignore-unrecognized-cops',
          '--format json',
          @repository.directory
        ]

        command = "bundle exec rubocop #{lint_options.join(' ')}"
      ensure
        stdout, _stderr, status = Open3.capture3(command)
        @json_result = stdout
        @result = {
          status: status.exitstatus,
          result: JSON.parse(@json_result, symbolize_names: true)
        }
        self
      end

      def parse
        @offense_count = @result[:result][:summary][:offense_count]
        return [] if @offense_count.zero?

        @result[:result][:files].reject { _1[:offenses].empty? }.map do |file|
          offenses = file[:offenses].map do |offence|
            {
              message: offence[:message],
              name: offence[:cop_name],
              line: offence[:location][:line],
              column: offence[:location][:column]
            }
          end
          { path: file[:path], offenses: }
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
