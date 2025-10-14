import 'package:flutter/material.dart';
import 'package:intelliresume/data/models/cv_model.dart';
//qimport 'package:intelliresume/models/cv_model.dart';

/// Widget para exibir informações resumidas de um CV
class CVCard extends StatelessWidget {
  final CVModel cv;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isCompact;

  const CVCard({
    super.key,
    required this.cv,
    required this.onEdit,
    required this.onDelete,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          isCompact
              ? const EdgeInsets.symmetric(vertical: 4.0)
              : const EdgeInsets.symmetric(vertical: 12.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          cv.title,
                          style: Theme.of(context).textTheme.titleLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (cv.status == ResumeStatus.draft)
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Chip(
                            label: Text('Rascunho'),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar currículo',
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Excluir currículo',
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Criado em: ${cv.dateCreated.day}/${cv.dateCreated.month}/${cv.dateCreated.year}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (!isCompact) ...[
              const SizedBox(height: 8),
              if (cv.evaluation != null)
                Text(
                  'Avaliação: ${cv.evaluation}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (cv.translation != null)
                Text(
                  'Tradução: ${cv.translation}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (cv.correctionsCount != null)
                Text(
                  'Correções: ${cv.correctionsCount}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
