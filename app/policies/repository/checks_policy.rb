# frozen_string_literal: true

class RepositoryPolicy
  class CheckPolicy < ApplicationPolicy
    def show?
      owner?
    end

    def create?
      owner?
    end

    def owner?
      user == record.repository.user
    end
  end
end
