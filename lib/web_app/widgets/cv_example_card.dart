import 'package:flutter/material.dart';

class CVExampleCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final bool isPremium;

  const CVExampleCard({
    super.key,
    required this.title,
    required this.imagePath,
    this.isPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Exemplo de currículo $title${isPremium ? " (Premium)" : ""}',
      child: FocusableActionDetector(
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: Image.asset(
                      imagePath,
                      semanticLabel: 'Exemplo visual do currículo $title',
                    ),
                  ),
                  if (isPremium)
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}