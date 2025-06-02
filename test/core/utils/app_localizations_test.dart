import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:intelliresume/core/utils/app_localizations.dart';

void main() {
  test('AppLocalizations returns correct translations', () {
    final t = AppLocalizations(Locale('pt', 'BR'));

    expect(t.objective, 'Objetivo');
    expect(t.experiences, 'Experiências');
    expect(t.educations, 'Formações');
    expect(t.skills, 'Habilidades');
    expect(t.socialLinks, 'Links Sociais');
    expect(t.save, 'Salvar');
  });
}
