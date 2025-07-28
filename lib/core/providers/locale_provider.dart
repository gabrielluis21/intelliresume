import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Este provider armazena o Locale (idioma e país) atual da aplicação.
// A UI (MaterialApp) deve ouvir este provider para reconstruir
// a árvore de widgets com o novo idioma quando ele for alterado.
final localeProvider = StateProvider<Locale>((ref) {
  // O idioma padrão é definido como Português.
  // Altere aqui se desejar outro idioma inicial.
  return const Locale('pt');
});
