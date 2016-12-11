# frozen_string_literal: true
require_relative '../api'
require 'time'
require 'rack/app/test'

describe Api do
  include Rack::App::Test

  rack_app described_class

  let(:juice) do
    Model::Juice.new(
      id: SecureRandom.uuid,
      name: 'Mango',
      created_at: Time.iso8601('2016-12-11T02:00:00.123Z'),
      updated_at: Time.iso8601('2016-12-11T02:05:00.123Z'),
      size: 750
    )
  end
  let(:juice2) do
    Model::Juice.new(
      id: SecureRandom.uuid,
      name: 'Tomato',
      created_at: Time.iso8601('2016-11-11T02:00:00.123Z'),
      updated_at: Time.iso8601('2016-11-11T02:05:00.123Z'),
      size: 500
    )
  end

  def protobuf_timestamp(time)
    Google::Protobuf::Timestamp.new.tap { |e| e.from_time(time) }
  end

  def juice_pb_msg(juice)
    Wire::Juice.new(id: juice.id,
                    name: juice.name,
                    created_at: protobuf_timestamp(juice.created_at),
                    updated_at: protobuf_timestamp(juice.updated_at),
                    size: juice.size)
  end

  def juice_pb(juice)
    Wire::Juice.encode(juice_pb_msg(juice))
  end

  def juice_list_pb(juices)
    Wire::JuiceList.encode(
      Wire::JuiceList.new(juices: juices.map { |e| juice_pb_msg(e) })
    )
  end

  before do
    Repo::Juice.collection.delete_many
  end

  describe 'get /juices' do
    before do
      post(url: '/juices', payload: juice_pb(juice))
      post(url: '/juices', payload: juice_pb(juice2))
    end
    subject { get(url: '/juices') }

    it { expect(subject.body).to eq juice_list_pb([juice, juice2]) }
    it { expect(subject.status).to eq 200 }
    it do
      msg = Wire::JuiceList.decode(subject.body)
      expect(msg.juices.size).to eq 2
    end
  end

  describe 'post /juices' do
    subject { post(url: '/juices', payload: juice_pb(juice)) }

    it { expect(subject.body).to eq juice_pb(juice) }
    it { expect(subject.status).to eq 200 }
    it do
      expect { subject }.to change {
        Repo::Juice.collection.count
      }.from(0).to(1)
    end
    it do
      subject
      expect(Repo::Juice.collection.find(_id: juice.id).first)
        .to eq({
                 "_id" => juice.id,
                 "created_at" => juice.created_at,
                 "name" => juice.name,
                 "size" => juice.size,
                 "updated_at" => juice.updated_at
               })
    end
  end

  describe 'get /juices/:id' do
    before { post(url: '/juices', payload: juice_pb(juice2)) }
    subject { get(url: "/juices/#{juice2.id}") }

    it { expect(subject.body).to eq juice_pb(juice2) }
    it { expect(subject.status).to eq 200 }
  end
end
