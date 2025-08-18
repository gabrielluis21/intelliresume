import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

// Modelo de dados simples para cada template
class TemplateInfo {
  final String name;
  final String imagePath;

  const TemplateInfo({required this.name, required this.imagePath});
}

class TemplateGallerySection extends StatefulWidget {
  final GlobalKey galleryKey;
  const TemplateGallerySection({super.key, required this.galleryKey});

  @override
  State<TemplateGallerySection> createState() => _TemplateGallerySectionState();
}

class _TemplateGallerySectionState extends State<TemplateGallerySection> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  // Lista de todos os templates que serão exibidos
  final List<TemplateInfo> templates = [
    TemplateInfo(
      name: 'Padrão IntelliResume',
      imagePath: 'images/cv/cv_intelliresume_pattern_mock.png',
    ),
    TemplateInfo(name: 'Clássico', imagePath: 'images/cv/cv_classic_mock.png'),
    TemplateInfo(
      name: 'Primeiro Emprego',
      imagePath: 'images/cv/cv_studant_first_job_mock.png',
    ),
    TemplateInfo(
      name: 'Moderno com Sidebar',
      imagePath: 'images/cv/cv_modern_with_sidebar_mock.png',
    ),
    TemplateInfo(
      name: 'Linha do Tempo',
      imagePath: 'images/cv/cv_timeline_mock.png',
    ),
    TemplateInfo(
      name: 'Infográfico',
      imagePath: 'images/cv/cv_infographic_mock.png',
    ),
    TemplateInfo(name: 'Dev Tec', imagePath: 'images/cv/cv_dev_tec_mock.png'),
    TemplateInfo(
      name: 'Internacional',
      imagePath: 'images/cv/cv_internacional_mock.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0D47A1);

    return Container(
      key: widget.galleryKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Text(
            'Nossos Modelos',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: brandBlue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Designs criados para impressionar. Do clássico ao moderno, encontre o ideal para você.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          FocusableActionDetector(
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (intent) => _controller.nextPage(),
              ),
            },
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.arrowRight): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.arrowLeft): ActivateIntent(),
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider.builder(
                  carouselController: _controller,
                  itemCount: templates.length,
                  itemBuilder: (context, index, realIndex) {
                    final template = templates[index];
                    return Semantics(
                      label:
                          'Visualização do modelo de currículo: ${template.name}',
                      child: Image.asset(
                        template.imagePath,
                        fit: BoxFit.contain,
                        semanticLabel: 'Exemplo do modelo ${template.name}',
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 0.7,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    autoPlay: false, // Essencial para acessibilidade
                  ),
                ),
                // Botão Anterior
                Positioned(
                  left: 20,
                  child: Semantics(
                    label: 'Ver modelo anterior',
                    button: true,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: brandBlue,
                        size: 30,
                      ),
                      onPressed: () => _controller.previousPage(),
                    ),
                  ),
                ),
                // Botão Próximo
                Positioned(
                  right: 20,
                  child: Semantics(
                    label: 'Ver próximo modelo',
                    button: true,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: brandBlue,
                        size: 30,
                      ),
                      onPressed: () => _controller.nextPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Nome do template atual
          Text(
            templates[_current].name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Indicadores de "pontinhos"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                templates.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap:
                        () => _controller.animateToPage(
                          entry.key,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.linear,
                        ),
                    child: Semantics(
                      label:
                          'Ir para o modelo ${entry.key + 1}: ${entry.value.name}',
                      button: true,
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : brandBlue)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
