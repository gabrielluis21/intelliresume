import 'package:flutter/material.dart';
import 'package:intelliresume/web_app/widgets/feature_card.dart';

class ClickableFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ClickableFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Botão para ver modelos. Funcionalidade: $title. Descrição: $description',
      child: GestureDetector(
        onTap: onTap,
        child: FeatureCard(
          icon: icon,
          title: title,
          description: description,
        ),
      ),
    );
  }
}
