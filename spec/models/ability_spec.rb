require 'spec_helper'

describe Ability do

  before :each do
    @site = FactoryGirl.create(:site)

    @admin_membership     = FactoryGirl.create(:admin,      :site => @site)
    @designer_membership  = FactoryGirl.create(:designer,   :site => @site)
    @author_membership    = FactoryGirl.create(:author,     :site => @site)
    @logged_in_membership = FactoryGirl.create(:logged_in,  :site => @site)

    @admin     = @admin_membership.account
    @designer  = @designer_membership.account
    @author    = @author_membership.account
    @logged_in = @logged_in_membership.account

    @guest = nil # FactoryGirl.create(    :guest,      :site => @site)
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

    context 'authorization' do
      it 'should allow reading of pages from everyone' do
        should allow_permission_from :read, @admin, @site
        should allow_permission_from :read, @designer, @site
        should allow_permission_from :read, @author, @site
        should allow_permission_from :read, @logged_in, @site
        should allow_permission_from :read, @guest, @site
      end


      it 'logged_in-protected pages forbid reading of pages from everyone but guests' do
        subject.required_role = 'logged_in'
        should allow_permission_from :read, @admin, @site
        should allow_permission_from :read, @designer, @site
        should allow_permission_from :read, @author, @site
        should allow_permission_from :read, @logged_in, @site
        should_not allow_permission_from :read, @guest, @site
      end

      context 'author pages' do
        before { subject.required_role = 'author' }

        it 'should allow reading of pages from authors and up only' do
          should allow_permission_from :read, @admin, @site
          should allow_permission_from :read, @designer, @site
          should allow_permission_from :read, @author, @site
          should_not allow_permission_from :read, @logged_in, @site
          should_not allow_permission_from :read, @guest, @site
        end
      end

      context 'designer pages' do
        before { subject.required_role = 'designer' }

        it 'should allow reading of pages from designer and admin only' do
          should allow_permission_from :read, @admin, @site
          should allow_permission_from :read, @designer, @site
          should_not allow_permission_from :read, @author, @site
          should_not allow_permission_from :read, @logged_in, @site
          should_not allow_permission_from :read, @guest, @site
        end
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
