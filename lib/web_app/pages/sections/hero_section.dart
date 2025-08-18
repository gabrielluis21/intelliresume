import 'package:flutter/material.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onCTAPressed;
  static const Color _brandBlue = Color(0xFF0D47A1);

  const HeroSection({super.key, required this.onCTAPressed});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monte seu currículo com inteligência!',
                  semanticsLabel: 'Monte seu currículo com inteligência!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Use IA para montar, traduzir e melhorar seu currículo com base no país desejado.',
                  semanticsLabel:
                      'Use IA para montar, traduzir e melhorar seu currículo com base no país desejado.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Semantics(
                  button: true,
                  label: 'Experimente agora',
                  child: ElevatedButton(
                    onPressed: onCTAPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Experimente agora'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40, height: 40),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Image.asset(
              'images/logo-transparente.png',
              fit: BoxFit.contain,
              height: 250,
              width: 360,
              semanticLabel: 'Logo do IntelliResume',
            ),
          ),
        ],
      ),
    );
  }
}
