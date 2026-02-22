import 'package:equatable/equatable.dart';

/// Domain entity for a photography package.
class Package extends Equatable {
  const Package({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.duration,
    this.includedServices = const [],
    this.sampleImageUrls = const [],
    this.category,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String duration;
  final List<String> includedServices;
  final List<String> sampleImageUrls;
  final String? category;

  @override
  List<Object?> get props => [id, title, description, price, duration, includedServices, sampleImageUrls, category];
}
