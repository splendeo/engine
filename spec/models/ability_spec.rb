require 'spec_helper'

describe Ability do

  before :each do
    @site = FactoryGirl.create(:site)

    @admin_membership     = FactoryGirl.create(:admin,    :site => @site)
    @designer_membership  = FactoryGirl.create(:designer, :site => @site)
    @author_membership    = FactoryGirl.create(:author,   :site => @site)
    @client_membership    = FactoryGirl.create(:client,   :site => @site)
    @employee_membership  = FactoryGirl.create(:employee, :site => @site)

    @admin     = @admin_membership.account
    @designer  = @designer_membership.account
    @author    = @author_membership.account
    @client    = @client_membership.account
    @employee  = @employee_membership.account

    @guest = nil
  end

  context 'pages' do

    subject { Page.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer, author)' do
        should     allow_permission_from :manage, @admin, @site
        should     allow_permission_from :manage, @designer, @site
        should_not allow_permission_from :manage, @author, @site
      end
    end

    context 'touching' do
      it 'should allow touching of pages from (author)' do
        should allow_permission_from :touch, @author, @site
      end
    end

    context 'browsing' do
      it 'should be possible for everyone on public pages' do
        should allow_permission_from :browse, @admin, @site
        should allow_permission_from :browse, @designer, @site
        should allow_permission_from :browse, @author, @site
        should allow_permission_from :browse, @client, @site
        should allow_permission_from :browse, @employee, @site
        should allow_permission_from :browse, @guest, @site
      end

      it 'should be possible for everyone but guests and employees on client-protected pages' do
        subject.required_role = 'client'
        should allow_permission_from :browse, @admin, @site
        should allow_permission_from :browse, @designer, @site
        should allow_permission_from :browse, @author, @site
        should allow_permission_from :browse, @client, @site
        should_not allow_permission_from :browse, @employee, @site
        should_not allow_permission_from :browse, @guest, @site
      end

      it 'should be possible for everyone but guests and clients on employee-protected pages' do
        subject.required_role = 'employee'
        should allow_permission_from :browse, @admin, @site
        should allow_permission_from :browse, @designer, @site
        should allow_permission_from :browse, @author, @site
        should allow_permission_from :browse, @employee, @site
        should_not allow_permission_from :browse, @client, @site
        should_not allow_permission_from :browse, @guest, @site
      end
    end
  end

  context 'content instance' do

    subject { ContentInstance.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer, author)' do
        should allow_permission_from :manage, @admin, @site
        should allow_permission_from :manage, @designer, @site
        should allow_permission_from :manage, @author, @site
      end
    end

  end

  context 'content type' do

    subject { ContentType.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer)' do
        should     allow_permission_from :manage, @admin, @site
        should     allow_permission_from :manage, @designer, @site
        should_not allow_permission_from :manage, @author, @site
      end
    end

    # context 'touching' do
    #   it 'should allow touching of pages from (author)' do
    #     should_not allow_permission_from :touch, @author
    #   end
    # end

  end

  context 'theme assets' do

    subject { ThemeAsset.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer)' do
        should     allow_permission_from :manage, @admin, @site
        should     allow_permission_from :manage, @designer, @site
        should_not allow_permission_from :manage, @author, @site
      end
    end

    context 'touching' do
      it 'should allow touching of pages from (author)' do
        should allow_permission_from :touch, @author, @site
      end
    end

  end

  context 'site' do

    subject { Site.new }

    context 'management' do
      it 'should allow management of pages from (admin)' do
        should     allow_permission_from :manage, @admin, @site
        should_not allow_permission_from :manage, @designer, @site
        should_not allow_permission_from :manage, @author, @site
      end
    end

    context 'importing' do
      it 'should allow importing of sites from (designer)' do
        should     allow_permission_from :import, @designer, @site
        should_not allow_permission_from :import, @author, @site
      end
    end

    context 'pointing' do
      it 'should allow importing of sites from (designer)' do
        should     allow_permission_from :point, @designer, @site
        should_not allow_permission_from :point, @author, @site
      end
    end

  end

  context 'membership' do

    subject { Membership.new }

    context 'management' do
      it 'should allow management of memberships from (admin, designer)' do
        should     allow_permission_from :manage, @admin, @site
        should     allow_permission_from :manage, @designer, @site
        should_not allow_permission_from :manage, @author, @site
      end
    end

    context 'granting admin' do
      it 'should allow only admins to grant admin role' do
        should     allow_permission_from :grant_admin, @admin, @site
        should_not allow_permission_from :grant_admin, @designer, @site
        should_not allow_permission_from :grant_admin, @author, @site
      end

    end

  end

end
