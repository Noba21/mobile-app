import '../../domain/entities/package.dart';

/// DTO for package API response.
class PackageModel {
  const PackageModel({
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

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    final services = json['included_services'] ?? json['includedServices'];
    final images = json['sample_images'] ?? json['sampleImageUrls'] ?? json['sample_images'];
    return PackageModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: _parsePrice(json['price']),
      duration: json['duration'] as String? ?? '',
      includedServices: services is List ? (services as List).map((e) => e.toString()).toList() : [],
      sampleImageUrls: _parseImageUrls(images),
      category: json['category'] as String?,
    );
  }

  static double _parsePrice(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static List<String> _parseImageUrls(dynamic value) {
    if (value is! List) return [];
    return value.map((e) {
      if (e is String) return e;
      if (e is Map && e['url'] != null) return e['url'] as String;
      return e.toString();
    }).where((s) => s.isNotEmpty).toList();
  }

  Package toEntity() => Package(
        id: id,
        title: title,
        description: description,
        price: price,
        duration: duration,
        includedServices: includedServices,
        sampleImageUrls: sampleImageUrls,
        category: category,
      );
}
