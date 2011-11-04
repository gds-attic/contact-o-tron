Feature: Administering contacts
  In order to supply and maintain government contact information
  I want to create, view, edit and destroy contacts

  Scenario: List contacts
    Given some contacts exist
    Then I should be able to see all the contacts in alphabetical order

  Scenario: View a contact
    Given a contact exists
    Then I should be able to see the contact's details