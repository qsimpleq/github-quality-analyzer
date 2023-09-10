# frozen_string_literal: true

require 'open3'

class LintJavascriptService
  attr_reader :repository, :json_result, :parsed_result, :result, :offense_count

  def initialize(repository)
    @repository = repository
    @offense_count = 0
    @parsed_result = []
  end

  def perform
    command = "yarn run eslint #{lint_options.join(' ')} #{@repository.directory}"
    stdout, stderr, status = Open3.capture3(command)

    @result = { status: status.exitstatus }
    if @result[:status] > 1 && stderr
      @result[:error] = stderr
      return false
    end

    @json_result = stdout.split("\n")[2]
    @result[:result] = JSON.parse(@json_result, symbolize_names: true)
    parse_result
  end

  private

  def find_config
    repository_config = "#{@repository.directory}/.eslintrc"
    extension = %w[js json yml].find { File.exist?("#{repository_config}.#{_1}") }
    return unless extension

    "#{repository_config}.#{extension}"
  end

  def lint_options
    config_path = find_config
    config = config_path ? "--config #{config_path}" : '--no-eslintrc'

    [config, '--format json']
  end

  def parse_result
    @parsed_result = @result[:result].reject { _1[:messages].empty? }.map do |file|
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
    true
  rescue StandardError
    false
  end
end
