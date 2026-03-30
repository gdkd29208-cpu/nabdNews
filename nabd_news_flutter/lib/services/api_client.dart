import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/app_user.dart';
import '../models/journalist_group.dart';
import '../models/news_article.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String endpoint, [Map<String, String>? query]) {
    final base = '${ApiConfig.baseUrl}/$endpoint';
    final uri = Uri.parse(base);
    return query == null ? uri : uri.replace(queryParameters: query);
  }

  Future<Map<String, dynamic>> _get(
    String endpoint, {
    Map<String, String>? query,
  }) async {
    final response = await _client.get(_uri(endpoint, query));
    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> _post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      _uri(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final decoded =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    if (decoded['success'] != true) {
      throw ApiException(
        decoded['message']?.toString() ?? 'فشل الطلب من الخادم.',
      );
    }

    return decoded;
  }

  List<NewsArticle> _parseNewsList(dynamic data) {
    final items = data as List<dynamic>? ?? const [];
    return items
        .map(
          (item) => NewsArticle.fromApi(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  List<JournalistGroup> _parseGroups(dynamic data) {
    final items = data as List<dynamic>? ?? const [];
    return items
        .map(
          (item) =>
              JournalistGroup.fromApi(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<List<NewsArticle>> fetchNews() async {
    final payload = await _get('get_news.php');
    return _parseNewsList(payload['data']);
  }

  Future<List<JournalistGroup>> fetchGroups({int? userId}) async {
    final query = userId == null
        ? null
        : <String, String>{'user_id': '$userId'};
    final payload = await _get('get_groups.php', query: query);
    return _parseGroups(payload['data']);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final payload = await _post(
      'login_user.php',
      body: {'email': email.trim(), 'password': password},
    );
    return AppUser.fromApi(
      Map<String, dynamic>.from(payload['data']['user'] as Map),
    );
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String adminSecret,
  }) async {
    final payload = await _post(
      'register_user.php',
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'admin_secret': adminSecret.trim(),
      },
    );
    return AppUser.fromApi(
      Map<String, dynamic>.from(payload['data']['user'] as Map),
    );
  }

  Future<AppUser> fetchProfile(int userId) async {
    final payload = await _get(
      'get_profile.php',
      query: {'user_id': '$userId'},
    );
    return AppUser.fromApi(
      Map<String, dynamic>.from(payload['data']['user'] as Map),
    );
  }

  Future<AppUser> updateProfile({
    required int userId,
    required String name,
    required String email,
    String password = '',
  }) async {
    final payload = await _post(
      'update_user.php',
      body: {
        'user_id': userId,
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      },
    );
    return AppUser.fromApi(
      Map<String, dynamic>.from(payload['data']['user'] as Map),
    );
  }

  Future<void> createArticle({
    required int userId,
    required String title,
    required String description,
    required String category,
    required String sourceName,
    required String sourceUrl,
    required String imageUrl,
    required bool isBreaking,
  }) async {
    await _post(
      'add_news.php',
      body: {
        'user_id': userId,
        'title': title.trim(),
        'description': description.trim(),
        'category': category,
        'source_name': sourceName.trim(),
        'source_url': sourceUrl.trim(),
        'image_url': imageUrl.trim(),
        'is_breaking': isBreaking,
      },
    );
  }

  Future<void> updateArticle({
    required int userId,
    required int articleId,
    required String title,
    required String description,
    required String category,
    required String sourceName,
    required String sourceUrl,
    required String imageUrl,
    required bool isBreaking,
  }) async {
    await _post(
      'update_news.php',
      body: {
        'user_id': userId,
        'id': articleId,
        'title': title.trim(),
        'description': description.trim(),
        'category': category,
        'source_name': sourceName.trim(),
        'source_url': sourceUrl.trim(),
        'image_url': imageUrl.trim(),
        'is_breaking': isBreaking,
      },
    );
  }

  Future<void> deleteArticle({
    required int userId,
    required int articleId,
  }) async {
    await _post('delete_news.php', body: {'user_id': userId, 'id': articleId});
  }

  Future<void> createGroup({
    required int userId,
    required String name,
    required String description,
    required String password,
  }) async {
    await _post(
      'create_group.php',
      body: {
        'user_id': userId,
        'name': name.trim(),
        'description': description.trim(),
        'password': password,
      },
    );
  }

  Future<void> joinGroup({
    required int userId,
    required int groupId,
    required String password,
  }) async {
    await _post(
      'join_group.php',
      body: {'user_id': userId, 'group_id': groupId, 'password': password},
    );
  }
}
