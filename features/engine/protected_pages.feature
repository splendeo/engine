Feature: Protected Pages
  In order to ensure that some pages are not visible to everyone
  As a user testing security access
  I will be restricted based on my role

Background:
    Given I have the site: "test site" set up
    And a protected page named "secret" visible for "logged_in"

  Scenario: A guest user will see a login prompt
    When I view the rendered page at "/secret"
    Then I am redirected to "/admin/login"
