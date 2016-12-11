# frozen_string_literal: true
require 'repo/juice'

module UseCase
  class Index
    def run
      Repo::Juice.all
    end
  end
end
