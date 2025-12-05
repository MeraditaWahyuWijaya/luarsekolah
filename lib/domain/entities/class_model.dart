class ClassModel {
  final String id;
  final String title;
  final int price;
  final String category; // Populer / SPL
  final String thumbnailUrl;

  ClassModel({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.thumbnailUrl,
  });

  factory ClassModel.fromMap(Map<String, dynamic> map, String id) {
    return ClassModel(
      id: id,
      title: map['title'] ?? '',
      price: map['price'] ?? 0,
      category: map['category'] ?? 'Populer',
      thumbnailUrl: map['thumbnailUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'category': category,
      'thumbnailUrl': thumbnailUrl,
    };
  }
}
