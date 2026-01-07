import 'api/api_client.dart';
import 'api/auth_api.dart';
import 'api/feed_api.dart';
import 'api/applications_api.dart';
import 'api/chat_api.dart';
import 'api/saves_api.dart';
import 'api/posts_api.dart';
import 'api/media_api.dart';
import 'package:flutter/foundation.dart';

class AppServices {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000';
      default:
        return 'http://127.0.0.1:8000';
    }
  }

  static final ApiClient client = ApiClient(baseUrl: baseUrl);

  static final AuthApi auth = AuthApi(client);
  static final FeedApi feed = FeedApi(client);
  static final ApplicationsApi applications = ApplicationsApi(client);
  static final ChatApi chat = ChatApi(client);
  static final SavesApi saves = SavesApi(client);
  static final PostsApi posts = PostsApi(client);
  static final MediaApi media = MediaApi(client);
}
