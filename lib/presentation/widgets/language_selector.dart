import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intelliresume/core/providers/languages/translate_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/generated/app_localizations.dart';

final selectedLanguageProvider = StateProvider<String>((ref) => 'en');
final translatedResumeProvider = FutureProvider.family<ResumeData, ResumeData>((
  ref,
  resume,
) async {
  final targetLang = ref.watch(selectedLanguageProvider);
  final translator = ref.watch(fallbackTranslatorProvider);
  return await translator.translate(resume, targetLang);
});

class LanguageSelector extends ConsumerWidget {
  final ResumeData resume;
  final void Function(ResumeData translated)? onTranslated;

  const LanguageSelector({super.key, required this.resume, this.onTranslated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLang = ref.watch(selectedLanguageProvider);
    final isLoading = ref.watch(translatedResumeProvider(resume)).isLoading;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.languageSelector_selectLanguage),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: selectedLang,
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Text(l10n.languageSelector_english),
            ),
            DropdownMenuItem(
              value: 'es',
              child: Text(l10n.languageSelector_spanish),
            ),
            DropdownMenuItem(
              value: 'fr',
              child: Text(l10n.languageSelector_french),
            ),
            DropdownMenuItem(
              value: 'de',
              child: Text(l10n.languageSelector_german),
            ),
          ],
          onChanged: (lang) async {
            if (lang != null) {
              ref.read(selectedLanguageProvider.notifier).state = lang;
              final translated = await ref.read(
                translatedResumeProvider(resume).future,
              );
              onTranslated?.call(translated);
            }
          },
        ),
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
