import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';

// Define um StateProvider que irá gerenciar o Locale atual da aplicação.
// O valor inicial é o Locale para Português do Brasil ('pt').
final localeProvider = StateProvider<Locale>((ref) => const Locale('pt'));

// NOVO: Provider para o formatador de moeda
final currencyFormatProvider = StateProvider<NumberFormat>((ref) {
  // Ouve o provider de locale
  final locale = ref.watch(localeProvider);

  // Retorna o formatador correto com base no locale
  if (locale.languageCode == 'pt') {
    return NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  } else {
    // Padrão para inglês/dólar
    return NumberFormat.currency(locale: 'en_US', symbol: 'US\$');
  }
});