# frozen_string_literal: true
require 'types'
require 'dry-struct'

module Model
  class Juice < Dry::Struct
    attribute :id, Types::Strict::String
    attribute :name, Types::Strict::String
    attribute :created_at, Types::Strict::Time
    attribute :updated_at, Types::Strict::Time
    attribute :size, Types::Strict::Int
  end
end
