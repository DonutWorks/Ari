module Admin
  class BaseService
  protected
    def success(params = {})
      { status: :success }.merge(params)
    end

    def failure(params = {})
      { status: :failure }.merge(params)
    end
  end
end