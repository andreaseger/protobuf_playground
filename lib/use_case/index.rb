require "repo/juice"

module UseCase
  class Show
    def run
      Repo::Juice.all
    end
  end
end
