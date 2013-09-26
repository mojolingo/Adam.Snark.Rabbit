Feature: Contact lookup
  As a user of Adam
  In order to contact people
  Adam should be able to help me find the contact details I need

  Scenario: Asking for contact details without being logged in
    Given I have no current session
    When I go to Adam's homepage
    And I ask "Who is Joe Bloggs"
    Then Adam should say "Sorry, I can only help you with that if you login."

  Scenario: Asking for contact details without any integrations
    Given I am logged in as Ben
    When I go to Adam's homepage
    And I ask "Who is Joe Bloggs"
    Then Adam should say "Sorry, you have not configured any integrations for contact lookup."

  Scenario: Asking for a contact unknown to Base
    Given I am logged in as Ben
    And I have setup Base integration
    When I go to Adam's homepage
    And I ask "Who is Joe Bloggs"
    Then Adam should say "Sorry, I have no record of Joe Bloggs."

  Scenario: Asking for a known contact from Base
    Given I am logged in as Ben
    And I have setup Base integration
    And my Base account has a contact named "Joe Bloggs" with the phone number "+1 (515) 555-8765"
    When I go to Adam's homepage
    And I ask "Who is Joe Bloggs"
    Then Adam should say "Joe Bloggs\nPhone: +1 (515) 555-8765\n\nhttps://app.futuresimple.com/crm/contacts/26299451",
