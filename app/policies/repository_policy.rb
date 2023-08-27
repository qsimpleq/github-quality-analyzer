# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def index?
    user
  end

  def show?
    user == record.user
  end

  def new?
    user
  end

  def create?
    new?
  end

  def owner?
    user == record.repository.user
  end
end
