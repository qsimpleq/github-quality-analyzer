# frozen_string_literal: true

if ENV['RAILS_ENV'] == 'production'
  Sentry.init do |config|
    config.dsn = 'https://475afdec43ccfaab6b16aa20c658f8f9@o4505362171428864.ingest.sentry.io/4505628729999360'
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 0.1
    # or
    config.traces_sampler = lambda do |_context|
      true
    end
  end
end
