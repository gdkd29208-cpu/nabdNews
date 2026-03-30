import 'package:flutter/widgets.dart';

import '../models/app_user.dart';
import '../models/journalist_group.dart';
import '../models/news_article.dart';
import '../services/api_client.dart';

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
  AppState({ApiClient? apiClient}) : this._(apiClient: apiClient);

  AppState._({
    ApiClient? apiClient,
    List<NewsArticle> articles = const [],
    List<JournalistGroup> groups = const [],
    AppUser? currentUser,
    bool isInitialized = false,
  }) : _apiClient = apiClient ?? ApiClient(),
       _articles = List<NewsArticle>.from(articles),
       _groups = List<JournalistGroup>.from(groups),
       _currentUser = currentUser,
       _isInitialized = isInitialized;

  static const demoAdminSecret = 'nabd-admin';

  factory AppState.preview() {
    return AppState._(
      isInitialized: true,
      currentUser: const AppUser(
        id: 99,
        name: 'مستخدم تجريبي',
        email: 'preview@nabd.app',
      ),
      articles: [
        NewsArticle(
          id: 1,
          authorId: 99,
          authorName: 'مستخدم تجريبي',
          title: 'نبض نيوز',
          content: 'خبر تجريبي لعرض نسخة Flutter داخل الاختبارات.',
          category: 'تكنولوجيا',
          source: 'Preview API',
          publishedAt: DateTime(2026, 3, 30, 10),
        ),
      ],
      groups: [
        JournalistGroup(
          id: 1,
          name: 'كروب تجريبي',
          ownerId: 99,
          ownerName: 'مستخدم تجريبي',
          memberCount: 1,
          isMember: true,
          createdAt: DateTime(2026, 3, 30, 10),
        ),
      ],
    );
  }

  final ApiClient _apiClient;

  List<NewsArticle> _articles = [];
  List<JournalistGroup> _groups = [];
  AppUser? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _lastError;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get lastError => _lastError;

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
    return groups.where((group) => group.isMember).toList(growable: false);
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
    final authorName = article.authorName?.trim();
    if (authorName != null && authorName.isNotEmpty) {
      return authorName;
    }
    return article.source;
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

  Future<void> bootstrap() async {
    await refreshData(showLoader: true);
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> refreshData({bool showLoader = true}) async {
    if (showLoader) {
      _setLoading(true);
    }

    try {
      _lastError = null;
      _articles = await _apiClient.fetchNews();
      _groups = await _apiClient.fetchGroups(userId: _currentUser?.id);
    } catch (error) {
      _lastError = _readableMessage(error);
    } finally {
      if (showLoader) {
        _setLoading(false);
      } else {
        notifyListeners();
      }
    }
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);

    try {
      _lastError = null;
      _currentUser = await _apiClient.login(email: email, password: password);
      await refreshData(showLoader: false);
      return true;
    } catch (error) {
      _lastError = _readableMessage(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String adminSecret = '',
  }) async {
    if (password != confirmPassword) {
      return 'تأكيد كلمة المرور غير مطابق.';
    }

    _setLoading(true);

    try {
      _lastError = null;
      _currentUser = await _apiClient.register(
        name: name,
        email: email,
        password: password,
        adminSecret: adminSecret,
      );
      await refreshData(showLoader: false);
      return null;
    } catch (error) {
      final message = _readableMessage(error);
      _lastError = message;
      return message;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await refreshData(showLoader: true);
  }

  Future<String?> updateProfile({
    required String name,
    required String email,
    String password = '',
  }) async {
    final user = _currentUser;
    if (user == null) {
      return 'لازم تسجل دخول أولاً.';
    }

    _setLoading(true);

    try {
      _lastError = null;
      _currentUser = await _apiClient.updateProfile(
        userId: user.id,
        name: name,
        email: email,
        password: password,
      );
      await refreshData(showLoader: false);
      return null;
    } catch (error) {
      final message = _readableMessage(error);
      _lastError = message;
      return message;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> saveArticle({
    NewsArticle? existingArticle,
    required String title,
    required String content,
    required String category,
    required String source,
    required String link,
    required String imageUrl,
    bool isBreaking = false,
  }) async {
    final user = _currentUser;
    if (user == null) {
      return 'سجل دخولك حتى تنشر أو تعدل خبر.';
    }

    _setLoading(true);

    try {
      _lastError = null;
      if (existingArticle == null) {
        await _apiClient.createArticle(
          userId: user.id,
          title: title,
          description: content,
          category: category,
          sourceName: source.isEmpty ? user.name : source,
          sourceUrl: link,
          imageUrl: imageUrl,
          isBreaking: isBreaking,
        );
      } else {
        await _apiClient.updateArticle(
          userId: user.id,
          articleId: existingArticle.id,
          title: title,
          description: content,
          category: category,
          sourceName: source.isEmpty ? user.name : source,
          sourceUrl: link,
          imageUrl: imageUrl,
          isBreaking: isBreaking,
        );
      }
      await refreshData(showLoader: false);
      return null;
    } catch (error) {
      final message = _readableMessage(error);
      _lastError = message;
      return message;
    } finally {
      _setLoading(false);
    }
  }

  bool canEditArticle(NewsArticle article) {
    final user = _currentUser;
    if (user == null) {
      return false;
    }
    return user.isAdmin || article.authorId == user.id;
  }

  Future<bool> deleteArticle(int articleId) async {
    final user = _currentUser;
    if (user == null) {
      return false;
    }

    _setLoading(true);

    try {
      _lastError = null;
      await _apiClient.deleteArticle(userId: user.id, articleId: articleId);
      await refreshData(showLoader: false);
      return true;
    } catch (error) {
      _lastError = _readableMessage(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> createGroup({
    required String name,
    required String description,
    required String password,
    required String confirmPassword,
  }) async {
    final user = _currentUser;
    if (user == null) {
      return 'لازم تسجل دخول أولاً.';
    }
    if (password != confirmPassword) {
      return 'تأكيد كلمة مرور الكروب غير مطابق.';
    }

    _setLoading(true);

    try {
      _lastError = null;
      await _apiClient.createGroup(
        userId: user.id,
        name: name,
        description: description,
        password: password,
      );
      await refreshData(showLoader: false);
      return null;
    } catch (error) {
      final message = _readableMessage(error);
      _lastError = message;
      return message;
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> joinGroup({
    required int groupId,
    required String password,
  }) async {
    final user = _currentUser;
    if (user == null) {
      return 'لازم تسجل دخول أولاً.';
    }

    _setLoading(true);

    try {
      _lastError = null;
      await _apiClient.joinGroup(
        userId: user.id,
        groupId: groupId,
        password: password,
      );
      await refreshData(showLoader: false);
      return null;
    } catch (error) {
      final message = _readableMessage(error);
      _lastError = message;
      return message;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _readableMessage(Object error) {
    if (error is ApiException) {
      return error.message;
    }
    return 'حدث خطأ غير متوقع في الاتصال مع الـ API.';
  }
}
