# frozen_string_literal: true

module AnyClients
  def octokit(user)
    @octokit ||= ApplicationContainer[:octokit].new(access_token: user.token,
                                                    auto_paginate: true)
  end

  def redis
    @redis ||= ApplicationContainer[:redis]
  end
end
