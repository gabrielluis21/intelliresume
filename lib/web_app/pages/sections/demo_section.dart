import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/web_app/pages/sections/section_title.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // New import

class DemoSection extends StatefulWidget { // Changed to StatefulWidget
  const DemoSection({super.key});

  @override
  State<DemoSection> createState() => _DemoSectionState();
}

class _DemoSectionState extends State<DemoSection> {
  late YoutubePlayerController _controller; // Declare controller

  @override
  void initState() {
    super.initState();
    // Initialize the controller with a placeholder video ID
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
    _controller.dispose(); // Dispose the controller
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
                          _controller.play(); // Play the video
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
                child: YoutubePlayer( // Replaced Container with YoutubePlayer
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
