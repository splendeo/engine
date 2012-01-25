require 'spec_helper'

describe Ability do

  before :each do
    @site = FactoryGirl.create(:site)
    @account = FactoryGirl.create(:account)

    @admin  = FactoryGirl.create(:membership, :account => FactoryGirl.build(:account), :site => FactoryGirl.build(:site))
    @designer  = FactoryGirl.create(:membership, :account => FactoryGirl.build(:account), :site => @site, :role => %(designer))
    @author = FactoryGirl.create(:membership, :account => FactoryGirl.build(:account), :site => @site, :role => %(author))
    @logged_in = FactoryGirl.create(:logged_in, :site => @site)
    @guest = FactoryGirl.create(:guest, :site => @site)
  end

  context 'pages' do

    subject { Page.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer, author)' do
        should     allow_permission_from :manage, @admin
        should     allow_permission_from :manage, @designer
        should_not allow_permission_from :manage, @author
      end
    end

    context 'touching' do
      it 'should allow touching of pages from (author)' do
        should allow_permission_from :touch, @author
      end
    end

    context 'authorization' do
      it 'should allow reading of pages from everyone' do
        should allow_permission_from :read, @admin
        should allow_permission_from :read, @designer
        should allow_permission_from :read, @author
        should allow_permission_from :read, @logged_in
        should allow_permission_from :read, @guest
      end


      it 'logged_in-protected pages forbid reading of pages from everyone but guests' do
        subject.required_role = 'logged_in'
        #should allow_permission_from :read, @admin
        #should allow_permission_from :read, @designer
        #should allow_permission_from :read, @author
        #should allow_permission_from :read, @logged_in
        should_not allow_permission_from :read, @guest
      end
   
      context 'author pages' do
        before { subject.required_role = 'author' }

        it 'should allow reading of pages from authors and up only' do
          should allow_permission_from :read, @admin
          should allow_permission_from :read, @designer
          should allow_permission_from :read, @author
          should_not allow_permission_from :read, @logged_in
          should_not allow_permission_from :read, @guest
        end
      end

      context 'designer pages' do
        before { subject.required_role = 'designer' }

        it 'should allow reading of pages from designer and admin only' do
          should allow_permission_from :read, @admin
          should allow_permission_from :read, @designer
          should_not allow_permission_from :read, @author
          should_not allow_permission_from :read, @logged_in
          should_not allow_permission_from :read, @guest
        end
      end

      context 'admin-protected pages' do
        before { subject.required_role = 'admin' }

        it 'should allow reading of pages from designer and admin only' do
          should allow_permission_from :read, @admin
          should_not allow_permission_from :read, @designer
          should_not allow_permission_from :read, @author
          should_not allow_permission_from :read, @logged_in
          should_not allow_permission_from :read, @guest
        end
      end
    end
  end

  context 'content instance' do

    subject { ContentInstance.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer, author)' do
        should allow_permission_from :manage, @admin
        should allow_permission_from :manage, @designer
        should allow_permission_from :manage, @author
      end
    end

  end

  context 'content type' do

    subject { ContentType.new }

    context 'management' do
      it 'should allow management of pages from (admin, designer)' do
        should     allow_permission_from :manage, @admin
        should     allow_permission_from :manage, @designer
        should_not allow_permission_from :manage, @author
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
        should     allow_permission_from :manage, @admin
        should     allow_permission_from :manage, @designer
        should_not allow_permission_from :manage, @author
      end
    end

    context 'touching' do
      it 'should allow touching of pages from (author)' do
        should allow_permission_from :touch, @author
      end
    end

  end

  context 'site' do

    subject { Site.new }

    context 'management' do
      it 'should allow management of pages from (admin)' do
        should     allow_permission_from :manage, @admin
        should_not allow_permission_from :manage, @designer
        should_not allow_permission_from :manage, @author
      end
    end

    context 'importing' do
      it 'should allow importing of sites from (designer)' do
        should     allow_permission_from :import, @designer
        should_not allow_permission_from :import, @author
      end
    end

    context 'pointing' do
      it 'should allow importing of sites from (designer)' do
        should     allow_permission_from :point, @designer
        should_not allow_permission_from :point, @author
      end
    end

  end

  context 'membership' do

    subject { Membership.new }

    context 'management' do
      it 'should allow management of memberships from (admin, designer)' do
        should     allow_permission_from :manage, @admin
        should     allow_permission_from :manage, @designer
        should_not allow_permission_from :manage, @author
      end
    end

    context 'granting admin' do
      it 'should allow only admins to grant admin role' do
        should     allow_permission_from :grant_admin, @admin
        should_not allow_permission_from :grant_admin, @designer
        should_not allow_permission_from :grant_admin, @author
      end

    end

  end

end
