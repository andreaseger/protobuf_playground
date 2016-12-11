# frozen_string_literal: true
require 'wire'
require 'repo/juice'

module UseCase
  class Create
    def initialize(payload:)
      @juice = Wire.decode(:juice, payload)
    end

    def run
      Repo::Juice.save(juice: @juice)
    end
  end
end
