import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import '../../../../core/providers/resume/cv_provider.dart';

class AboutMeForm extends ConsumerStatefulWidget {
  final String about;

  const AboutMeForm({super.key, required this.about});

  @override
  ConsumerState<AboutMeForm> createState() => _AboutMeFormState();
}

class _AboutMeFormState extends ConsumerState<AboutMeForm> {
  late TextEditingController _aboutController;
  late AppLocalizations l10n;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.about);
    l10n = AppLocalizations.of(context)!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context)!;
  }

  @override
  void didUpdateWidget(AboutMeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.about != widget.about) {
      _aboutController.text = widget.about;
    }
  }

  void _updatebout() {
    ref.read(localResumeProvider.notifier).updateAbout(_aboutController.text);
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: 6,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              controller: _aboutController,
              onChanged: (value) {
                ref.read(localResumeProvider.notifier).updateAbout(value);
              },
              decoration: InputDecoration(
                labelText: l10n.aboutMe,
                hintText: l10n.aboutMeEmptyPlaceholder,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _updatebout(),
                    child: Text(l10n.save),
                  ),
                  Semantics(
                    label: l10n.resumeForm_aboutMeTab,
                    child: IconButton(
                      tooltip: l10n.aboutMeForm_removeAboutMe,
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref.read(localResumeProvider.notifier).updateAbout('');
                        _aboutController.clear();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
