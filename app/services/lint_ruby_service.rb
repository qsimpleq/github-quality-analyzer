# frozen_string_literal: true

require 'open3'

class LintRubyService
  attr_reader :repository, :json_result, :parsed_result, :result, :offense_count

  def initialize(repository)
    @repository = repository
    @offense_count = 0
    @parsed_result = []
  end

  def perform
    Dir.chdir(@repository.directory)

    command = "bundle exec rubocop #{lint_options.join(' ')}"
    stdout, stderr, status = Open3.capture3(command)

    @result = { status: status.exitstatus }
    if @result[:status] > 1 && stderr
      @result[:error] = stderr
      return false
    end

    @json_result = stdout
    @result[:result] = JSON.parse(@json_result, symbolize_names: true)
    Dir.chdir(Rails.root)
    parse_result
  end

  private

  def find_config
    repository_config = "#{@repository.directory}/.rubocop.yml"
    unless File.exist?(repository_config)
      default_config = "#{Gem::Specification.find_by_name('rubocop').gem_dir}/config/default.yml"
      FileUtils.cp(default_config, repository_config)
    end

    "--config #{repository_config}"
  end

  def lint_options
    [
      '--safe',
      '--ignore-unrecognized-cops',
      '--format json',
      find_config
    ]
  end

  def parse_result
    @offense_count = @result[:result][:summary][:offense_count]
    return true if @offense_count.zero?

    @parsed_result = @result[:result][:files].reject { _1[:offenses].empty? }.map do |file|
      offenses = file[:offenses].map do |offence|
        {
          message: offence[:message],
          name: offence[:cop_name],
          line: offence[:location][:line],
          column: offence[:location][:column]
        }
      end
      { path: file[:path].delete_prefix("#{@repository.directory}/"), offenses: }
    end
    true
  rescue StandardError
    false
  end
end
