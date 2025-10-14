import 'cv_data.dart';

enum ResumeStatus { draft, finalized }

/// Modelo de dados de um currículo salvo, contendo metadados e o conteúdo.
class CVModel {
  final String id;
  final String title;
  final ResumeData data;
  final DateTime dateCreated;
  final DateTime lastModified;
  final ResumeStatus status;
  final String? evaluation;
  final String? translation;
  final int? correctionsCount;

  CVModel({
    required this.id,
    required this.title,
    required this.data,
    required this.dateCreated,
    required this.lastModified,
    required this.status,
    this.evaluation,
    this.translation,
    this.correctionsCount,
  });

  /// Cria uma instância a partir de JSON
  factory CVModel.fromJson(Map<String, dynamic> json) {
    return CVModel(
      id: json['id'] as String,
      title: json['title'] as String,
      data: ResumeData.fromJson(json['data']),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      lastModified: DateTime.parse(json['lastModified'] as String),
      status: ResumeStatus.values.firstWhere(
        (e) => e.toString() == 'ResumeStatus.${json['status']}',
        orElse: () => ResumeStatus.draft,
      ),
      evaluation: json['evaluation'] as String?,
      translation: json['translation'] as String?,
      correctionsCount: json['correctionsCount'] as int?,
    );
  }

  /// Converte a instância para JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'data': data.toMap(),
        'dateCreated': dateCreated.toIso8601String(),
        'lastModified': lastModified.toIso8601String(),
        'status': status.name,
        'evaluation': evaluation,
        'translation': translation,
        'correctionsCount': correctionsCount,
      };

  @override
  String toString() =>
      'CVModel(id: $id, title: $title, status: $status, lastModified: $lastModified)';
}
