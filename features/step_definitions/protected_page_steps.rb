def create_protected_page(page_slug, role)
  @home = @site.pages.where(:slug => "index").first || FactoryGirl.create(:page)
  page = @site.pages.create(
    :slug => page_slug,
    :body => "<html><body>protected page</body></html>",
    :parent => @home,
    :title => "protected page",
    :published => true,
    :raw_template => nil,
    :required_role => role )
  page.should be_valid
  page
end

Given /^a protected page named "([^"]*)" visible for "([^"]*)"$/ do |page_slug, role|
  @page = create_protected_page(page_slug, role)
end
