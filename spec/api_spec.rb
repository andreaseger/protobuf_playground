# frozen_string_literal: true
require_relative '../api'
require "time"
require 'rack/app/test'

describe Api do
  include Rack::App::Test

  rack_app described_class

  def protobuf_timestamp(time)
    pp Google::Protobuf::Timestamp.new.tap{ |e| e.from_time(time)}
  end

  let(:juice) do
    Model::Juice.new(
      id: SecureRandom.uuid,
      name: "Mango",
      created_at: Time.iso8601("2016-12-11T02:00:00.123Z"),
      updated_at: Time.iso8601("2016-12-11T02:05:00.123Z"),
      size: 750
    )
  end

  let(:juice_pb) do
    obj = Wire::Juice.new(id: juice.id,
                          name: juice.name,
                          created_at: protobuf_timestamp(juice.created_at),
                          updated_at: protobuf_timestamp(juice.updated_at),
                          size: juice.size)
    Wire::Juice.encode(obj)
  end

  before do
    Repo::Juice.collection.delete_many
  end

  # describe 'get /juices' do
  #   subject { get(url: '/juices') }

  #   it { expect(subject.body).to eq 'index' }
  #   it { expect(subject.status).to eq 200 }
  # end
  describe 'post /juices' do
    subject { post(url: '/juices', payload: juice_pb)}

    it { expect(subject.body).to eq juice_pb }
    it { expect(subject.status).to eq 200 }
    it do
      expect{subject}.to change{
        Repo::Juice.collection.count
      }.from(0).to(1)
    end
  end

  describe 'get /juices/:id' do
    before do
      post(url: '/juices', payload: juice_pb)
    end
    subject { get(url: "/juices/#{juice.id}") }

    it { expect(subject.body).to eq juice_pb }
    it { expect(subject.status).to eq 200 }
  end
  # describe 'patch /juices/:id' do
  #   subject { patch(url: '/juices/1234', payload: 'mango') }

  #   it { expect(subject.body).to eq 'update 1234, mango' }
  #   it { expect(subject.status).to eq 200 }
  # end
  # describe 'delete /juices/:id' do
  #   subject { delete(url: '/juices/1234') }

  #   it { expect(subject.body).to eq 'delete 1234' }
  #   it { expect(subject.status).to eq 200 }
  # end
end
