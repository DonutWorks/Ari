module Authenticates
  class BaseService
    def initialize(current_club)
      @current_club = current_club
    end

  protected
    def current_club
      @current_club
    end

    def success(params = {})
      { status: :success }.merge(params)
    end

    def failure(params = {})
      { status: :failure }.merge(params)
    end
  end
end