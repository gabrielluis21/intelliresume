/// Modelo de dados de um currículo
class CVModel {
  final String id;
  final String title;
  final DateTime dateCreated;
  final String? evaluation;
  final String? translation;
  final int? correctionsCount;

  CVModel({
    required this.id,
    required this.title,
    required this.dateCreated,
    this.evaluation,
    this.translation,
    this.correctionsCount,
  });

  /// Cria uma instância a partir de JSON
  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      id: json['id'] as String,
      title: json['title'] as String,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      evaluation: json['evaluation'] as String?,
      translation: json['translation'] as String?,
      correctionsCount: json['correctionsCount'] as int?,
    );
  }

  /// Converte a instância para JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateCreated': dateCreated.toIso8601String(),
    'evaluation': evaluation,
    'translation': translation,
    'correctionsCount': correctionsCount,
  };

  @override
  String toString() =>
      'CVModel(id: $id, title: $title, dateCreated: $dateCreated, evaluation: $evaluation, translation: $translation, correctionsCount: $correctionsCount)';
}
