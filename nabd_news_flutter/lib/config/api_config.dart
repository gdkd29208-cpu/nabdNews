import 'package:flutter/foundation.dart';

class ApiConfig {
  static const _overrideBaseUrl = String.fromEnvironment('NABD_API_BASE_URL');

  static String get baseUrl {
    if (_overrideBaseUrl.isNotEmpty) {
      return _overrideBaseUrl;
    }

    if (kIsWeb) {
      return 'http://localhost/news_api';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2/news_api';
      default:
        return 'http://127.0.0.1/news_api';
    }
  }
}
