class Category {
  final String id;
  final String title;
  final String description;
  final bool testsAvailable;

  Category({
    required this.id,
    required this.title,
    required this.description,
    required this.testsAvailable,
  });

    factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      title: json['name'] ?? 'No Title', // ✅ Fix is here
      description: json['description'] ?? 'No description',
      testsAvailable: json['testsAvailable'] ?? false, // This field is missing from response
    );
  }


}
