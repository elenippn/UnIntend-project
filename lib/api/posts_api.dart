import 'api_client.dart';

class PostsApi {
  final ApiClient client;
  PostsApi(this.client);

  Future<Map<String, dynamic>> createCompanyPost({
    required String title,
    required String description,
    String? location,
  }) async {
    final res = await client.post('/posts', data: {
      'title': title,
      'description': description,
      'location': location,
    });
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<List<dynamic>> listMyCompanyPosts() async {
    final res = await client.get('/posts/me');
    return res.data as List<dynamic>;
  }

  Future<List<dynamic>> listCompanyPostsForUser(int companyUserId) async {
    final res = await client.get('/posts/company/$companyUserId');
    return res.data as List<dynamic>;
  }

  Future<Map<String, dynamic>> createProfilePost({
    required String title,
    required String description,
    String? category,
  }) async {
    final res = await client.post('/profile-posts', data: {
      'title': title,
      'description': description,
      'category': category,
    });
    return Map<String, dynamic>.from(res.data as Map);
  }

  Future<List<dynamic>> listMyProfilePosts() async {
    final res = await client.get('/profile-posts/me');
    return res.data as List<dynamic>;
  }

  Future<List<dynamic>> listProfilePostsForStudent(int studentUserId) async {
    final res = await client.get('/profile-posts/$studentUserId');
    return res.data as List<dynamic>;
  }
}