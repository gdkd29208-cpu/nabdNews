class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.source,
    required this.publishedAt,
    this.authorId,
    this.authorName,
    this.link,
    this.imageUrl,
    this.isBreaking = false,
  });

  factory NewsArticle.fromApi(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as int,
      authorId: json['user_id'] as int?,
      authorName: json['user_name'] as String?,
      title: (json['title'] ?? '') as String,
      content: (json['description'] ?? '') as String,
      category: ((json['category'] ?? 'عام') as String).trim(),
      source: ((json['source_name'] ?? 'المصدر') as String).trim(),
      link: json['source_url'] as String?,
      imageUrl: json['image_url'] as String?,
      isBreaking: json['is_breaking'] == true || json['is_breaking'] == 1,
      publishedAt:
          DateTime.tryParse((json['published'] ?? '') as String) ??
          DateTime.now(),
    );
  }

  static const categories = <String>[
    'سياسة',
    'رياضة',
    'اقتصاد',
    'تكنولوجيا',
    'ثقافة',
    'عالمي',
    'عام',
  ];

  final int id;
  final int? authorId;
  final String? authorName;
  final String title;
  final String content;
  final String category;
  final String source;
  final String? link;
  final String? imageUrl;
  final bool isBreaking;
  final DateTime publishedAt;

  bool get isScraped => authorId == null;

  String get excerpt {
    const maxLength = 120;
    if (content.length <= maxLength) {
      return content;
    }
    return '${content.substring(0, maxLength).trim()}...';
  }
}
