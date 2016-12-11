# frozen_string_literal: true
require 'wire/types_pb'
require 'repo/juice'

module UseCase
  class Index
    def run
      juices = Repo::Juice.all
      Wire::JuiceList.new(juices: juices)
    end
  end
end
