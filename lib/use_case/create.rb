# frozen_string_literal: true
require 'wire/types_pb'
require 'repo/juice'

module UseCase
  class Create
    def initialize(payload:)
      @juice = Wire::Juice.decode(payload)
    end

    def run
      Repo::Juice.save(juice: @juice)
    end
  end
end
