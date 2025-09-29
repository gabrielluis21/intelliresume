import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/languages/translate_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selecione o Idioma:'),
        const SizedBox(height: 8),
        DropdownButton<String>(
          value: selectedLang,
          items: const [
            DropdownMenuItem(value: 'en', child: Text('🇺🇸 English')),
            DropdownMenuItem(value: 'es', child: Text('🇪🇸 Spanish')),
            DropdownMenuItem(value: 'fr', child: Text('🇫🇷 French')),
            DropdownMenuItem(value: 'de', child: Text('🇩🇪 German')),
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
