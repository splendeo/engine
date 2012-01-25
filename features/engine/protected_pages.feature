Feature: Protected Pages
  In order to ensure that some pages are not visible to everyone
  As an admin, designer, author or logged in user
  I will be restricted based on my role

Background:
    Given I have the site: "test site" set up
    And I have a designer, an author and a logged in user
    And a protected page named "secret" visible for "logged_in"
  Scenario: As an unauthenticated user
    Given I am not authenticated
    When I go to a protected page
    Then I should see "Log in"
