import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/di.dart';
import 'package:intelliresume/generated/app_localizations.dart';

// Provider para o stream de currículos
final resumesStreamProvider = StreamProvider.autoDispose<List<CVModel>>((ref) {
  final user = ref.watch(userProfileProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  final getResumesUsecase = ref.watch(getResumesUsecaseProvider);
  return getResumesUsecase(user.uid!);
});

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resumesAsync = ref.watch(resumesStreamProvider);
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyPage_myResumes)),
      body: resumesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (err, stack) => Center(
              child: Text(l10n.historyPage_anErrorOccurred(err.toString())),
            ),
        data: (resumes) {
          if (resumes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.folder_off_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.historyPage_noSavedResumes,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.historyPage_createNewResumeToStart,
                    style: const TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: resumes.length,
            itemBuilder: (context, index) {
              final resume = resumes[index];
              final formattedDate = DateFormat(
                'dd/MM/yyyy',
                'pt_BR',
              ).format(resume.lastModified);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: ListTile(
                  leading: Icon(
                    resume.status == ResumeStatus.draft
                        ? Icons.edit_note_rounded
                        : Icons.check_circle_outline_rounded,
                    color:
                        resume.status == ResumeStatus.draft
                            ? Colors.orange
                            : Colors.green,
                  ),
                  title: Text(
                    resume.title.isNotEmpty
                        ? resume.title
                        : l10n.historyPage_untitledResume,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(l10n.historyPage_updatedOn(formattedDate)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    context.go('/editor/${resume.id}');
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.historyPage_newResume),
        onPressed: () {
          // O 'new' será o identificador para criar um currículo em branco
          context.go('/editor/new');
        },
      ),
    );
  }
}
