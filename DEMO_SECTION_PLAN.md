## Plano para Implementar Player de Vídeo na `DemoSection`

**Objetivo:** Substituir o placeholder estático na `DemoSection` por um player de vídeo do YouTube incorporado e fazer com que o botão "Assistir Demonstração" reproduza o vídeo.

**Passos:**

1.  **Adicionar Dependência `youtube_player_flutter`:**
    *   Adicione `youtube_player_flutter` ao `pubspec.yaml`.
    *   Execute `flutter pub get`.

2.  **Atualizar Widget `DemoSection`:**
    *   Importe `package:youtube_player_flutter/youtube_player_flutter.dart`.
    *   Converta `DemoSection` para um `StatefulWidget` para gerenciar o `YoutubePlayerController`.
    *   Inicialize `YoutubePlayerController` com o ID do vídeo do YouTube.
    *   Substitua o placeholder `Container` por `YoutubePlayer`.
    *   Implemente o callback `onPressed` para o botão "Assistir Demonstração" para reproduzir o vídeo.
    *   Descarte o `YoutubePlayerController` no método `dispose()`.

3.  **Criar um ID de Vídeo Temporário:**
    *   Para agora, usaremos um ID de vídeo do YouTube de placeholder. O usuário poderá substituí-lo posteriormente.

**Modificações de Código Detalhadas (Conceitual):**

**`pubspec.yaml`:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  youtube_player_flutter: ^8.1.2 # Ou a versão mais recente
```

**`lib/web_app/pages/sections/demo_section.dart`:**

```dart
import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/web_app/pages/sections/section_title.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Nova importação

class DemoSection extends StatefulWidget { // Alterado para StatefulWidget
  const DemoSection({super.key});

  @override
  State<DemoSection> createState() => _DemoSectionState();
}

class _DemoSectionState extends State<DemoSection> {
  late YoutubePlayerController _controller; // Declaração do controller

  @override
  void initState() {
    super.initState();
    // Inicializa o controller com um ID de vídeo de placeholder
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ', // Placeholder: Rick Astley - Never Gonna Give You Up
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Descarta o controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          SectionTitle(
            title: l10n.demoSection_title,
            subtitle: l10n.demoSection_subtitle,
          ),
          Flex(
            direction: isMobile ? Axis.vertical : Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isMobile ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.demoSection_text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    Semantics(
                      button: true,
                      label: l10n.demoSection_ctaSemanticLabel,
                      child: ElevatedButton(
                        onPressed: () {
                          _controller.play(); // Reproduz o vídeo
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(l10n.demoSection_cta),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40, height: 40),
              Expanded(
                flex: isMobile ? 0 : 1,
                child: YoutubePlayer( // Substituído Container por YoutubePlayer
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```