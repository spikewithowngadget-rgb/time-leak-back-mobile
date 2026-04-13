/// Модель рекламного блока с API GET /api/v1/ads/next.
class AdModel {
  final String id;
  final String title;
  final String imageUrl;
  final String targetUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AdModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.targetUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      targetUrl: json['target_url'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
