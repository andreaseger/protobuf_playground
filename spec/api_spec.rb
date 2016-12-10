require_relative '../api'
require 'rack/app/test'

describe Api do
  include Rack::App::Test

  rack_app described_class

  describe 'get /juices' do
    subject{ get(url: '/juices') }

    it { expect(subject.body).to eq 'index'}
    it { expect(subject.status).to eq 200 }
  end
  describe 'post /juices' do
    subject{ post(url: '/juices', payload: "mango") }

    it { expect(subject.body).to eq 'create mango'}
    it { expect(subject.status).to eq 200 }
  end
  describe 'get /juices/:id' do
    subject{ get(url: '/juices/1234') }

    it { expect(subject.body).to eq 'show 1234'}
    it { expect(subject.status).to eq 200 }
  end
  describe 'patch /juices/:id' do
    subject{ patch(url: '/juices/1234', payload: "mango") }

    it { expect(subject.body).to eq 'update 1234, mango'}
    it { expect(subject.status).to eq 200 }
  end
  describe 'delete /juices/:id' do
    subject{ delete(url: '/juices/1234') }

    it { expect(subject.body).to eq 'delete 1234'}
    it { expect(subject.status).to eq 200 }
  end
end
