class Ability
  include CanCan::Ability

  ROLES = %w(admin designer author logged_in)

  def initialize(account, site)
    @account, @site = account, site

    alias_action :index, :show, :edit, :update, :to => :touch
    alias_action :index, :show, :to => :read

    setup_default_permissions!

    if @account && @site
      @membership = @site.memberships.where(:account_id => @account.id).first

      if @membership
        if @membership.admin?
          setup_admin_permissions!
        else

          setup_logged_in_permissions! if @membership.logged_in?

          setup_designer_permissions! if @membership.designer?

          setup_author_permissions!  if @membership.author?
        end
      end
    end
  end

  def setup_default_permissions!
    cannot :manage, :all
    can :read, Page do |page|
      page.required_role.nil?
    end
  end

  def setup_logged_in_permissions!
    can :read, Page do |page|
      page.required_role == 'logged_in'
    end
  end

  def setup_author_permissions!
    can :touch, [Page, ThemeAsset]
    can :sort, Page

    can :manage, [ContentInstance, Asset]

    can :touch, Site do |site|
      site == @site
    end

    can :read, Page do |page|
      %w{ author logged_in }.include? page.required_role
    end
  end

  def setup_designer_permissions!
    can :manage, Page

    can :manage, ContentInstance

    can :manage, ContentType

    can :manage, Snippet

    can :manage, ThemeAsset

    can :manage, Asset

    can :manage, Site do |site|
      site == @site
    end

    can :import, Site

    can :export, Site

    can :point, Site

    cannot :create, Site

    can :manage, Membership

    cannot :grant_admin, Membership

    cannot [:update, :destroy], Membership do |membership|
      @membership.account_id == membership.account_id || # can not edit myself
      membership.admin? # can not modify an administrator
    end
  end

  def setup_admin_permissions!
    can :manage, :all

    cannot [:update, :destroy], Membership do |membership|
      @membership.account_id == membership.account_id # can not edit myself
    end
  end
end
