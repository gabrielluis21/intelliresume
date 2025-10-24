import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intelliresume/data/models/cv_model.dart';

class RecentResumeCard extends StatelessWidget {
  final CVModel resume;
  final VoidCallback onTap;

  const RecentResumeCard({
    super.key,
    required this.resume,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = DateFormat('dd/MM/yy').format(resume.lastModified);
    final l10n = AppLocalizations.of(context)!;
    final bool isDraft = resume.status == ResumeStatus.draft;

    return SizedBox(
      child: Semantics(
        label: l10n.recentResume_semanticLabel(
          resume.title.isNotEmpty ? resume.title : l10n.recentResume_untitled,
        ),
        button: true,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 36,
                    color: theme.colorScheme.primary,
                    semanticLabel: l10n.recentResume_iconSemanticLabel,
                  ),
                  const Spacer(),
                  Text(
                    resume.title.isNotEmpty
                        ? resume.title
                        : l10n.recentResume_untitled,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    avatar: Icon(
                      isDraft
                          ? Icons.edit_note_rounded
                          : Icons.check_circle_outline_rounded,
                      size: 16,
                      color:
                          isDraft
                              ? Colors.orange.shade800
                              : Colors.green.shade800,
                    ),
                    label: Text(
                      isDraft
                          ? l10n.recentResume_draft
                          : l10n.recentResume_finalized,
                      style: theme.textTheme.labelSmall,
                    ),
                    backgroundColor:
                        isDraft
                            ? Colors.orange.shade100
                            : Colors.green.shade100,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    side: BorderSide.none,
                  ),
                  const Spacer(),
                  Text(
                    l10n.recentResume_editedOn(formattedDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddNewResumeCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddNewResumeCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: 160,
      height: 190,
      child: Semantics(
        label: l10n.addNewResume_semanticLabel,
        button: true,
        child: Card(
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.primary,
                  semanticLabel: l10n.addNewResume_iconSemanticLabel,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.addNewResume_create,
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
