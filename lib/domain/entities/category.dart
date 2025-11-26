import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String title;
  final String icon;

  const Category({
    required this.id,
    required this.title,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, icon];
}
