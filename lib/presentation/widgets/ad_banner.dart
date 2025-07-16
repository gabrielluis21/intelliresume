import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? const WebAdBanner() : const MobileBannerAdWidget();
  }
}

class WebAdBanner extends StatelessWidget {
  const WebAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    //if (!kIsWeb) return const SizedBox(); // Evita erro fora da Web
    return const SizedBox(); // Evita erro fora da Web

    /* const adUrl = 'https://meus-anuncios.web.app/ads.html'; // sua URL

    // Garantir que está sendo executado no web
    final iframe =
        web.HTMLIFrameElement()
          ..width = '300'
          ..height = '250'
          ..src = adUrl
          ..style.border = 'none';

    // ignore: undefined_prefixed_name
    // Essa linha só pode ser executada no Web
    // Aqui é seguro por causa do kIsWeb acima
    ui.platformViewRegistry.registerViewFactory(
      'ad-html',
      (int viewId) => iframe,
    );

    return const SizedBox(
      width: 300,
      height: 250,
      child: HtmlElementView(viewType: 'adview'),
    ); */
  }
}

class MobileBannerAdWidget extends StatefulWidget {
  const MobileBannerAdWidget({super.key});

  @override
  State<MobileBannerAdWidget> createState() => _MobileBannerAdWidgetState();
}

class _MobileBannerAdWidgetState extends State<MobileBannerAdWidget> {
  late BannerAd _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId:
          Theme.of(context).platform == TargetPlatform.android
              ? 'ca-app-pub-8831023011848191/8651629520' // Android adUnitId
              : 'ca-app-pub-8831023011848191/3417251196', // iOS adUnitId (substitute with your iOS adUnitId)
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isLoaded = true),
        onAdFailedToLoad: (ad, error) {
          debugPrint('BannerAd erro: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox();
    return Container(
      alignment: Alignment.center,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }
}
