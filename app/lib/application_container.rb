# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    autoload :Stubs, Rails.root.join('app/lib/stubs')
    register :octokit_client, -> { Stubs::OctokitClientStub }
  else
    register :octokit_client, -> { Octokit::Client }
  end
end
