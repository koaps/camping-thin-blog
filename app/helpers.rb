module App
  module Helpers
    def logged_in?
      !!@state.user_id
    end
    
    def require_login!
      unless logged_in?
        redirect Controllers::Login
        throw :halt
      end
    end
  end
end
