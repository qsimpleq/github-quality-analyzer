# frozen_string_literal: true

module AnyClients
  def octokit
    @octokit ||= ApplicationContainer[:octokit].new(access_token: current_user.token,
                                                    auto_paginate: true)
  end

  def redis
    @redis ||= ApplicationContainer[:redis]
  end
end
