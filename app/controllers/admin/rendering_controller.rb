module Admin
  class RenderingController < ActionController::Base

    include Locomotive::Routing::SiteDispatcher

    include Locomotive::Render

    before_filter :require_site
    before_filter :set_return_url
    before_filter :authenticate_admin!, :only => [:edit]
    before_filter :validate_site_membership, :only => [:edit]

    def show
      render_locomotive_page
    end

    def edit
      @editing = true
      render_locomotive_page
    end

    protected

    def set_return_url
      session['admin_return_to'] = request.path unless current_admin
    end

  end
end
