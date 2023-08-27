# frozen_string_literal: true

class Repository
  class Linter
    class Ruby
      attr_reader :repository, :json_result, :result, :offense_count

      def initialize(repository)
        @repository = repository
      end

      def lint
        Dir.chdir(@repository.directory)

        lint_options = [
          '--safe',
          '--ignore-unrecognized-cops',
          '--format json',
          select_config
        ]

        command = "bundle exec rubocop #{lint_options.join(' ')}"
      ensure
        stdout, stderr, status = Open3.capture3(command)

        @result = { status: status.exitstatus }
        if @result[:status] > 1 && stderr
          @result[:error] = stderr
        else
          @json_result = stdout
          @result[:result] = JSON.parse(@json_result, symbolize_names: true)
        end
        Dir.chdir(Rails.root)

        self
      end

      def parse
        @offense_count = @result[:result][:summary][:offense_count]
        return [] if @offense_count.zero?

        if @result[:status] > 1 && stderr
          @result[:error] = stderr
        else
          @json_result = stdout
          @result[:result] = JSON.parse(@json_result, symbolize_names: true)
        end
        Dir.chdir(Rails.root)

        @result[:result][:files].reject { _1[:offenses].empty? }.map do |file|
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
      end

      private

      def select_config
        repository_config = "#{@repository.directory}/.rubocop.yml"
        unless File.exist?(repository_config)
          default_config = "#{Gem::Specification.find_by_name('rubocop').gem_dir}/config/default.yml"
          FileUtils.cp(default_config, repository_config)
        end

        "--config #{repository_config}"
      end
    end
  end
end
