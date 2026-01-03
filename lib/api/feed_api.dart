import 'api_client.dart';

class FeedApi {
  final ApiClient client;
  FeedApi(this.client);

  Future<List<dynamic>> getStudentFeed() async {
    final res = await client.get('/feed/student');
    return res.data as List<dynamic>;
  }

  Future<void> decideOnPost(int postId, String decision) async {
    await client.post('/decisions/student/post', data: {
      "postId": postId,
      "decision": decision, // "LIKE" or "PASS"
    });
  }

  Future<void> savePost(int postId, bool saved) async {
    await client.post('/saves/student/post', data: {
      "postId": postId,
      "saved": saved,
    });
  }
}
