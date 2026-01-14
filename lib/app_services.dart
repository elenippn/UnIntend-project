import 'api/api_client.dart';
import 'api/auth_api.dart';
import 'api/feed_api.dart';
import 'api/applications_api.dart';
import 'api/chat_api.dart';
import 'api/saves_api.dart';
import 'api/posts_api.dart';

class AppServices {
  static final ApiClient client = ApiClient(baseUrl: "http://10.0.2.2:8000");

  static final AuthApi auth = AuthApi(client);
  static final FeedApi feed = FeedApi(client);
  static final ApplicationsApi applications = ApplicationsApi(client);
  static final ChatApi chat = ChatApi(client);
  static final SavesApi saves = SavesApi(client);
  static final PostsApi posts = PostsApi(client);
}
