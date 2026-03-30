import 'package:flutter/widgets.dart';

import '../models/app_user.dart';
import '../models/journalist_group.dart';
import '../models/news_article.dart';

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState notifier, required super.child})
    : super(notifier: notifier);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in widget tree.');
    return scope!.notifier!;
  }
}

class AppState extends ChangeNotifier {
  AppState._({
    required List<AppUser> users,
    required Map<int, String> passwords,
    required List<NewsArticle> articles,
    required List<JournalistGroup> groups,
  }) : _users = users,
       _passwords = passwords,
       _articles = articles,
       _groups = groups,
       _nextUserId = users.length + 1,
       _nextArticleId = articles.length + 1,
       _nextGroupId = groups.length + 1;

  static const demoAdminSecret = 'nabd-admin';

  final List<AppUser> _users;
  final Map<int, String> _passwords;
  final List<NewsArticle> _articles;
  final List<JournalistGroup> _groups;

  int _nextUserId;
  int _nextArticleId;
  int _nextGroupId;
  AppUser? _currentUser;

  factory AppState.seeded() {
    final users = <AppUser>[
      const AppUser(
        id: 1,
        name: 'هيبة التحرير',
        email: 'editor@nabd.app',
        isAdmin: true,
      ),
      const AppUser(id: 2, name: 'سارة الصحفية', email: 'sara@nabd.app'),
      const AppUser(id: 3, name: 'عمر المراسل', email: 'omar@nabd.app'),
    ];

    final articles = <NewsArticle>[
      NewsArticle(
        id: 1,
        authorId: 2,
        title: 'جلسة برلمانية تناقش خطة إعلامية وطنية جديدة',
        content:
            'ناقش عدد من النواب والصحفيين آلية الوصول إلى خطاب إعلامي أكثر مهنية، مع التركيز على سرعة نقل المعلومة ودقة التحقق من المصادر.',
        category: 'سياسة',
        source: 'مراسل نبض',
        publishedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NewsArticle(
        id: 2,
        authorId: 1,
        title: 'منصة تحرير رقمية تقلل وقت إنتاج الخبر إلى النصف',
        content:
            'اعتمد فريق التحرير الداخلي نظام متابعة جديد يربط المراسلين بالمحررين ويعرض حالة كل مادة من لحظة الاستلام حتى النشر.',
        category: 'تكنولوجيا',
        source: 'هيئة التحرير',
        publishedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      NewsArticle(
        id: 3,
        authorId: 3,
        title: 'ملف خاص عن استعدادات الأندية للموسم الجديد',
        content:
            'يستعرض التقرير حركة التعاقدات وأثر المعسكرات الخارجية على جاهزية الفرق، مع قراءة فنية لخطط المدربين قبل انطلاق المنافسات.',
        category: 'رياضة',
        source: 'قسم الرياضة',
        publishedAt: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      NewsArticle(
        id: 4,
        authorId: 2,
        title: 'تقرير اقتصادي: الأسواق تترقب موجة استثمارات جديدة',
        content:
            'ارتفعت التوقعات بدخول استثمارات نوعية في قطاعات التكنولوجيا والطاقة والنقل، وسط دعوات لرفع جودة البيانات المتاحة للمستثمرين.',
        category: 'اقتصاد',
        source: 'اقتصاد نبض',
        publishedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NewsArticle(
        id: 5,
        authorId: 1,
        title: 'افتتاح معرض ثقافي يركز على الصحافة البصرية',
        content:
            'المعرض يجمع مصورين وصحفيين شباب لتجربة صيغ سردية جديدة تعتمد الصورة، النص القصير، والوسائط التفاعلية.',
        category: 'ثقافة',
        source: 'الملحق الثقافي',
        publishedAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      ),
      NewsArticle(
        id: 6,
        title: 'وكالات عالمية تتابع محادثات اقتصادية إقليمية',
        content:
            'عدة عواصم تراقب نتائج الاجتماعات الاقتصادية الأخيرة، مع توقعات بإعلانات مشتركة تخص التجارة والطاقة خلال الأيام المقبلة.',
        category: 'عالمي',
        source: 'Bloomberg',
        link: 'https://example.com/global-economy',
        isScraped: true,
        publishedAt: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      NewsArticle(
        id: 7,
        title: 'اتفاق أولي على توسيع التعاون التقني بين مؤسسات إعلامية',
        content:
            'المحادثات ركزت على تبادل الخبرات في الذكاء الاصطناعي والتحقق الرقمي وتطوير غرف الأخبار السريعة.',
        category: 'تكنولوجيا',
        source: 'TechCrunch',
        link: 'https://example.com/media-tech',
        isScraped: true,
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NewsArticle(
        id: 8,
        title: 'مراقبون: الهدوء الرياضي قد يسبق صفقات مفاجئة',
        content:
            'تشير التقديرات إلى أن عدداً من الأندية ينتظر نهاية المرحلة الحالية لإعلان صفقاته الكبرى بعيداً عن الضجيج الإعلامي.',
        category: 'رياضة',
        source: 'BBC Sport',
        link: 'https://example.com/sports-market',
        isScraped: true,
        publishedAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ];

    final groups = <JournalistGroup>[
      JournalistGroup(
        id: 1,
        name: 'شبكة المراسلين',
        description:
            'مساحة سريعة لتنسيق التغطيات اليومية بين الميدان وغرفة الأخبار.',
        ownerId: 2,
        memberIds: const [2, 3],
        accessCode: 'press2026',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      JournalistGroup(
        id: 2,
        name: 'محررو التحقيقات',
        description:
            'كروب لتبادل الملفات والفرضيات الأولية قبل تحويلها إلى تحقيق كامل.',
        ownerId: 1,
        memberIds: const [1, 2],
        accessCode: 'investigate',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    return AppState._(
      users: users,
      passwords: <int, String>{
        1: 'admin123',
        2: 'journalist123',
        3: 'reporter123',
      },
      articles: articles,
      groups: groups,
    );
  }

  AppUser? get currentUser => _currentUser;

  List<AppUser> get users => List.unmodifiable(_users);

  List<NewsArticle> get news {
    final copy = [..._articles];
    copy.sort((left, right) => right.publishedAt.compareTo(left.publishedAt));
    return List.unmodifiable(copy);
  }

  List<NewsArticle> get featuredNews => news
      .where((article) => !article.isScraped)
      .take(4)
      .toList(growable: false);

  List<NewsArticle> get globalNews => news
      .where((article) => article.isScraped)
      .take(4)
      .toList(growable: false);

  List<NewsArticle> get myArticles {
    final user = _currentUser;
    if (user == null) {
      return const [];
    }
    return news
        .where((article) => article.authorId == user.id)
        .toList(growable: false);
  }

  List<JournalistGroup> get groups {
    final copy = [..._groups];
    copy.sort((left, right) => right.createdAt.compareTo(left.createdAt));
    return List.unmodifiable(copy);
  }

  List<JournalistGroup> groupsForUser(int userId) {
    return groups.where((group) => group.memberIds.contains(userId)).toList();
  }

  AppUser? userById(int? id) {
    if (id == null) {
      return null;
    }
    for (final user in _users) {
      if (user.id == id) {
        return user;
      }
    }
    return null;
  }

  NewsArticle? articleById(int id) {
    for (final article in _articles) {
      if (article.id == id) {
        return article;
      }
    }
    return null;
  }

  String authorLabelFor(NewsArticle article) {
    if (article.authorId == null) {
      return article.source.isEmpty ? 'مصدر خارجي' : article.source;
    }
    return userById(article.authorId)?.name ?? article.source;
  }

  List<NewsArticle> filterNews({
    required String category,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    return news
        .where((article) {
          final matchesCategory =
              category == 'الكل' || article.category == category;
          final haystack =
              '${article.title} ${article.content} ${article.source}'
                  .toLowerCase();
          final matchesQuery =
              normalizedQuery.isEmpty || haystack.contains(normalizedQuery);
          return matchesCategory && matchesQuery;
        })
        .toList(growable: false);
  }

  bool login({required String email, required String password}) {
    final normalizedEmail = email.trim().toLowerCase();
    for (final user in _users) {
      if (user.email.toLowerCase() == normalizedEmail &&
          _passwords[user.id] == password) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  String? register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String adminSecret = '',
  }) {
    if (name.trim().isEmpty || email.trim().isEmpty) {
      return 'الاسم والبريد الإلكتروني مطلوبان.';
    }
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل.';
    }
    if (password != confirmPassword) {
      return 'تأكيد كلمة المرور غير مطابق.';
    }
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.any((user) => user.email.toLowerCase() == normalizedEmail)) {
      return 'هذا البريد مستخدم بالفعل.';
    }

    final user = AppUser(
      id: _nextUserId++,
      name: name.trim(),
      email: normalizedEmail,
      isAdmin: adminSecret.trim() == demoAdminSecret,
    );
    _users.add(user);
    _passwords[user.id] = password;
    _currentUser = user;
    notifyListeners();
    return null;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  String? updateProfile({required String name, required String email}) {
    final user = _currentUser;
    if (user == null) {
      return 'لازم تسجل دخول أولاً.';
    }
    if (name.trim().isEmpty || email.trim().isEmpty) {
      return 'الاسم والبريد مطلوبان.';
    }

    final normalizedEmail = email.trim().toLowerCase();
    final emailTaken = _users.any(
      (candidate) =>
          candidate.id != user.id &&
          candidate.email.toLowerCase() == normalizedEmail,
    );
    if (emailTaken) {
      return 'هذا البريد مستخدم من حساب آخر.';
    }

    final index = _users.indexWhere((candidate) => candidate.id == user.id);
    _users[index] = user.copyWith(name: name.trim(), email: normalizedEmail);
    _currentUser = _users[index];
    notifyListeners();
    return null;
  }

  String? saveArticle({
    NewsArticle? existingArticle,
    required String title,
    required String content,
    required String category,
    required String source,
    required String link,
    required String imageUrl,
  }) {
    final user = _currentUser;
    if (user == null) {
      return 'سجل دخولك حتى تنشر أو تعدل خبر.';
    }
    if (title.trim().isEmpty || content.trim().isEmpty) {
      return 'العنوان والمحتوى مطلوبان.';
    }

    final cleanedSource = source.trim().isEmpty ? user.name : source.trim();
    final cleanedLink = link.trim().isEmpty ? null : link.trim();
    final cleanedImage = imageUrl.trim().isEmpty ? null : imageUrl.trim();

    if (existingArticle == null) {
      _articles.add(
        NewsArticle(
          id: _nextArticleId++,
          authorId: user.id,
          title: title.trim(),
          content: content.trim(),
          category: category,
          source: cleanedSource,
          link: cleanedLink,
          imageUrl: cleanedImage,
          publishedAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return null;
    }

    if (!canEditArticle(existingArticle)) {
      return 'ليس لديك صلاحية تعديل هذا الخبر.';
    }

    final index = _articles.indexWhere(
      (article) => article.id == existingArticle.id,
    );
    _articles[index] = existingArticle.copyWith(
      title: title.trim(),
      content: content.trim(),
      category: category,
      source: cleanedSource,
      link: cleanedLink,
      imageUrl: cleanedImage,
      publishedAt: DateTime.now(),
    );
    notifyListeners();
    return null;
  }

  bool canEditArticle(NewsArticle article) {
    final user = _currentUser;
    if (user == null) {
      return false;
    }
    return user.isAdmin || article.authorId == user.id;
  }

  bool deleteArticle(int articleId) {
    final article = articleById(articleId);
    if (article == null || !canEditArticle(article)) {
      return false;
    }
    _articles.removeWhere((candidate) => candidate.id == articleId);
    notifyListeners();
    return true;
  }

  String? createGroup({
    required String name,
    required String description,
    required String password,
    required String confirmPassword,
  }) {
    final user = _currentUser;
    if (user == null) {
      return 'لازم تسجل دخول أولاً.';
    }
    if (name.trim().isEmpty) {
      return 'اسم الكروب مطلوب.';
    }
    if (password.length < 6) {
      return 'كلمة مرور الكروب لازم تكون 6 أحرف على الأقل.';
    }
    if (password != confirmPassword) {
      return 'تأكيد كلمة مرور الكروب غير مطابق.';
    }

    _groups.add(
      JournalistGroup(
        id: _nextGroupId++,
        name: name.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        ownerId: user.id,
        memberIds: [user.id],
        accessCode: password,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
    return null;
  }

  String? joinGroup({required int groupId, required String password}) {
    final user = _currentUser;
    if (user == null) {
      return 'لازم تسجل دخول أولاً.';
    }

    final index = _groups.indexWhere((group) => group.id == groupId);
    if (index == -1) {
      return 'الكروب غير موجود.';
    }

    final group = _groups[index];
    if (group.accessCode != password) {
      return 'كلمة مرور الكروب غير صحيحة.';
    }
    if (group.memberIds.contains(user.id)) {
      return 'أنت منضم لهذا الكروب بالفعل.';
    }

    _groups[index] = group.copyWith(memberIds: [...group.memberIds, user.id]);
    notifyListeners();
    return null;
  }
}
