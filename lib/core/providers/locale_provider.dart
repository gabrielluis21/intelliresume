import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define um StateProvider que irá gerenciar o Locale atual da aplicação.
// O valor inicial é o Locale para Português do Brasil ('pt').
final localeProvider = StateProvider<Locale>((ref) => const Locale('pt'));