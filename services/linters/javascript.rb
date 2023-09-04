# frozen_string_literal: true

class Linters
  class Javascript
    attr_reader :repository, :json_result, :result, :offense_count

    def initialize(repository)
      @repository = repository
    end

    def lint
      lint_options = [
        select_config,
        '--format json'
      ]

      command = "yarn run eslint #{lint_options.join(' ')} #{@repository.directory}"
    ensure
      stdout, stderr, status = Open3.capture3(command)

      @result = { status: status.exitstatus }
      if @result[:status] > 1 && stderr
        @result[:error] = stderr
      else
        @json_result = stdout.split("\n")[2]
        @result[:result] = JSON.parse(@json_result, symbolize_names: true)
      end

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
        { path: file[:filePath].delete_prefix("#{@repository.directory}/"), offenses: }
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
