import 'package:flutter_test/flutter_test.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';

void main() {
  group('CVDataNotifier', () {
    late CvDataProviderNotifier notifier;

    setUp(() {
      notifier = CvDataProviderNotifier();
    });

    test('updateSocials adds new social link', () {
      final social = {'type': 'GitHub', 'url': 'https://github.com'};
      notifier.updateSocials(socials: [social]);
      expect(notifier.state.socials, [social]);
    });

    test('updateSocials removes items correctly', () {
      final social1 = {'type': 'GitHub', 'url': 'https://github.com'};
      final social2 = {'type': 'LinkedIn', 'url': 'https://linkedin.com'};

      notifier.updateSocials(socials: [social1, social2]);
      expect(notifier.state.socials.length, 2);

      notifier.updateSocials(socials: [social1]);
      expect(notifier.state.socials, [social1]);
    });
  });
}
