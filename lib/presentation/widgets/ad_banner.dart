import 'package:flutter/material.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    // Este é um widget de exemplo. Em um aplicativo real, você integraria
    // um SDK de anúncios aqui, como o google_mobile_ads.
    return Container(
      height: 60,
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          'Espaço para Anúncio',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
          semanticsLabel: 'Banner de anúncio',
        ),
      ),
    );
  }
}
