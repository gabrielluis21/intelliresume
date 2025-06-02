Feature: Resume Creation
  As a user
  I want to create and preview my resume
  So I can share my professional profile

  Scenario: Complete resume creation flow
    Given I am on the home screen
    When I tap "Criar Novo Currículo"
    And I enter "Software Engineer" in the objective field
    And I add an experience "Flutter Developer at XYZ"
    And I add a skill "Dart"
    And I add a social link "GitHub" with URL "https://github.com"
    And I tap "Salvar"
    Then I should see "Software Engineer" in the preview
    And I should see "Flutter Developer at XYZ" in the preview
    And I should see "Dart" in the preview
    And I should see "GitHub" in the preview