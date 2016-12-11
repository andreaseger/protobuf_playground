require "repo/juice"

module UseCase
  class Show
    def initialize(id:)
      @id = id
    end

    def run
      Repo::Juice.find(id: @id)
    end
  end
end
