import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///* Seção de Tipos para o Editor Focado

/// Enum que representa as diferentes seções do currículo que podem ser editadas.
enum SectionType { about, objective, experience, education, skill, social }

/// Classe que encapsula uma solicitação de edição, contendo a seção e, opcionalmente,
/// o índice de um item dentro de uma lista (ex: a segunda experiência).
@immutable
class EditRequest {
  const EditRequest({required this.section, this.index});
  final SectionType section;
  final int? index;
}

/// Provider para gerenciar a intenção de edição vinda do preview.
///
/// Quando um item no preview é tocado, este provider é atualizado com
/// um [EditRequest]. A UI do formulário escuta a este provider e reage
/// mudando de aba ou focando no item de edição correspondente.
final editRequestProvider = StateProvider<EditRequest?>((ref) => null);
