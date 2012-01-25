Given /^I have a designer, an author and a logged in user$/ do
  FactoryGirl.create(:designer,  :site => Site.first)
  FactoryGirl.create(:author,    :site => Site.first)
  FactoryGirl.create(:logged_in, :site => Site.first)
end

