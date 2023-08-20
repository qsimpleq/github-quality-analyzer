# frozen_string_literal: true

class Repository
  class Linter
    class Javascript
      attr_reader :repository, :json_result, :result, :offense_count

      def initialize(repository)
        @repository = repository
      end

      def run
        lint_options = [
          select_config,
          '--format json',
          @repository.directory
        ]

        command = "yarn run eslint #{lint_options.join(' ')}"
      ensure
        stdout, _stderr, status = Open3.capture3(command)
        @json_result = stdout.split("\n")[2]
        @result = {
          status: status.exitstatus,
          result: JSON.parse(@json_result, symbolize_names: true)
        }
        self
      end

      def parse
        @offense_count = 0
        @result[:result].reject { _1[:messages].empty? }.map do |file|
          offenses = file[:messages].map do |offence|
            @offense_count += 1
            {
              message: offence[:message],
              name: offence[:ruleId],
              line: offence[:line],
              column: offence[:column]
            }
          end
          { path: file[:filePath], offenses: }
        end
      end

      private

      def select_config
        config = find_config

        if config
          "--config #{config}"
        else
          '--no-eslintrc'
        end
      end

      def find_config
        repository_config = "#{@repository.directory}/.eslintrc"
        ext = %w[js json yml].find { File.exist?("#{repository_config}.#{_1}") }
        return unless ext

        "#{repository_config}.#{ext}"
      end
    end
  end
end
