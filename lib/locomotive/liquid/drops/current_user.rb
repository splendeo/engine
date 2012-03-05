module Locomotive
  module Liquid
    module Drops
      class CurrentUser < Base

        include ::Locomotive::Engine.routes.url_helpers # this should work but it doesn't; it says "Locomotive" doesn't exist!

        def logged_in?
          _source.present?
        end
        def name
          _source.name if logged_in?
        end
        def email
          _source.email if logged_in?
        end
        def logout_path
          destroy_locomotive_account_session_path
        end
        def login_path
          new_locomotive_account_session_path
        end

      end
    end
  end
end
