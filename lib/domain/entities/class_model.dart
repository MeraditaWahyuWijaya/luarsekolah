class ClassModel {
  final String id;
  String title;
  String description;
  String price;
  String category;
  String thumbnailUrl;
  bool isCompleted;

  ClassModel({
    required this.id,
    required this.title,
    this.description = '', 
    required this.price,
    required this.category,
    required this.thumbnailUrl,
    this.isCompleted = false, 
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? json['title'] ?? 'N/A';
    final price = json['price']?.toString() ?? '0';
    final category = json['category']?.toString() ?? 'General';

    return ClassModel(
      id: json['id']?.toString() ?? '',
      title: name,
      description: json['description'] ?? '', 
      price: price,
      category: category,
      thumbnailUrl: json['thumbnailUrl'] ?? json['thumbnail'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'price': price,
      'category': category.toLowerCase().contains('spl') ? 'SPL' : 'Populer',
      'thumbnailUrl': thumbnailUrl,
      'isCompleted': isCompleted,
    };
  }

  ClassModel copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    String? category,
    String? thumbnailUrl,
    bool? isCompleted,
  }) {
    return ClassModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}