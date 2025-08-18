import 'package:flutter/material.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.blueGrey.shade50,
      child: Center(
        child: Semantics(
          hint:
              'Copy Right - © IntelliResume 2025 - Todos os direitos reservados.',
          child: Text(
            '© IntelliResume 2025 - Todos os direitos reservados.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
