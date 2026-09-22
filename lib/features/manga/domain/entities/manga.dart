import 'package:equatable/equatable.dart';

class Manga extends Equatable {
  final String id;
  final String title;
  final String coverUrl;
  final String description;

  const Manga({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, coverUrl, description];
}
