class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishedAt,
    this.authorId,
    this.source = '',
    this.link,
    this.imageUrl,
    this.isScraped = false,
  });

  static const categories = <String>[
    'سياسة',
    'رياضة',
    'اقتصاد',
    'تكنولوجيا',
    'ثقافة',
    'عالمي',
  ];

  final int id;
  final int? authorId;
  final String title;
  final String content;
  final String category;
  final String source;
  final String? link;
  final String? imageUrl;
  final bool isScraped;
  final DateTime publishedAt;

  String get excerpt {
    const maxLength = 120;
    if (content.length <= maxLength) {
      return content;
    }
    return '${content.substring(0, maxLength).trim()}...';
  }

  NewsArticle copyWith({
    String? title,
    String? content,
    String? category,
    String? source,
    String? link,
    String? imageUrl,
    bool? isScraped,
    DateTime? publishedAt,
  }) {
    return NewsArticle(
      id: id,
      authorId: authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      source: source ?? this.source,
      link: link ?? this.link,
      imageUrl: imageUrl ?? this.imageUrl,
      isScraped: isScraped ?? this.isScraped,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }
}
