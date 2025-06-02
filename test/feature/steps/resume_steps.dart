import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_driver/flutter_driver.dart';

class ResumeSteps extends GivenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep() async {
    final app = FlutterDriver.connect();
    await app.waitUntilFirstFrameRendered();
  }
  
  @override
  RegExp get pattern => RegExp(r"I am on the home screen");
}

class TapButton extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep(String buttonText) async {
    await world.driver.tap(find.text(buttonText));
    await world.driver.waitFor(find.byType('Scaffold'));
  }
  
  @override
  RegExp get pattern => RegExp(r"I tap {string}");
}

class EnterObjective extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep(String text) async {
    final field = find.byType('TextFormField').first;
    await world.driver.tap(field);
    await world.driver.enterText(text);
  }
  
  @override
  RegExp get pattern => RegExp(r"I enter {string} in the objective field");
}

class AddExperience extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep(String experience) async {
    final field = find.byValueKey('experience-field');
    await world.driver.tap(field);
    await world.driver.enterText(experience);
    await world.driver.tap(find.text('Adicionar'));
  }
  
  @exp override
  RegExp get pattern => RegExp(r"I add an experience {string}");
}

class AddSkill extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep(String skill) async {
    final field = find.byValueKey('skill-field');
    await world.driver.tap(field);
    await world.driver.enterText(skill);
    await world.driver.tap(find.text('Adicionar'));
  }
  
  @override
  RegExp get pattern => RegExp(r"I add a skill {string}");
}

class AddSocialLink extends WhenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep(String platform, String url) async {
    await world.driver.tap(find.text('Escolha'));
    await world.driver.waitFor(find.text(platform));
    await world.driver.tap(find.text(platform));
    
    final urlField = find.byValueKey('social-url-field');
    await world.driver.tap(urlField);
    await world.driver.enterText(url);
    await world.driver.tap(find.text('Adicionar'));
  }
  
  @override
  RegExp get pattern => RegExp(r"I add a social link {string} with URL {string}");
}

class VerifyPreviewContent extends ThenWithWorld<FlutterWorld> {
  @override
  Future<void> executeStep(String text) async {
    await world.driver.waitFor(find.text(text));
  }
  
  @override
  RegExp get pattern => RegExp(r"I should see {string} in the preview");
}

// Configuração principal
void main() {
  executeFeature(
    featurePath: 'test/features/resume_creation.feature',
    steps: [
      ResumeSteps(),
      TapButton(),
      EnterObjective(),
      AddExperience(),
      AddSkill(),
      AddSocialLink(),
      VerifyPreviewContent(),
    ],
  );
}