import 'package:flutter/material.dart';
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

    final bool isDraft = resume.status == ResumeStatus.draft;

    return SizedBox(
      width: 250,
      height: 190,
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
                ),
                const Spacer(),
                Text(
                  resume.title.isNotEmpty
                      ? resume.title
                      : 'Currículo sem título',
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
                    isDraft ? 'Rascunho' : 'Finalizado',
                    style: theme.textTheme.labelSmall,
                  ),
                  backgroundColor:
                      isDraft ? Colors.orange.shade100 : Colors.green.shade100,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Text(
                  'Editado em: $formattedDate',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
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
    return SizedBox(
      width: 160,
      height: 190,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text('Criar Novo', style: theme.textTheme.titleSmall),
            ],
          ),
        ),
      ),
    );
  }
}
