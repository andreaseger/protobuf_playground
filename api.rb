# frozen_string_literal: true
require "model/juice"
require 'use_case/create'
require 'use_case/show'
require 'use_case/index'
require 'use_case/update'
require 'use_case/delete'

require "wire"
class Api < Rack::App

  serializer do |obj|
    p obj
    case obj
    when Model::Juice
      Wire.encode(obj)
    else
      obj.to_s
    end
  end

  namespace '/juices' do
    desc 'Create'
    post '/' do
      UseCase::Create.new(payload: payload).run
    end

    desc 'Read (show)'
    get '/:id' do
      UseCase::Show.new(id: params['id']).run
    end

    # desc 'Read (index)'
    # get '/' do
    #   UseCase::Index.new.run
    # end

    # desc 'Update'
    # patch '/:id' do
    #   "update #{params['id']}, #{payload}"
    # end

    # desc 'Delete'
    # delete '/:id' do
    #   UseCase::Delete.new(id: params["id"]).run
    # end
  end
end
