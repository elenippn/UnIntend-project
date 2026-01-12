import 'api_client.dart';
import '../models/company_candidate_dto.dart';
import '../models/internship_post_dto.dart';

class FeedApi {
  final ApiClient client;
  FeedApi(this.client);

  Future<List<InternshipPostDto>> getStudentFeed() async {
    final res = await client.get('/feed/student');
    final list = (res.data as List).cast<dynamic>();
    return list
        .map((e) =>
            InternshipPostDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
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

  Future<List<CompanyCandidateDto>> getCompanyFeed() async {
    final res = await client.get('/feed/company');
    final list = (res.data as List).cast<dynamic>();
    return list
        .map((e) =>
            CompanyCandidateDto.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> decideOnStudent(int studentUserId, String decision) async {
    await client.post('/decisions/company/student', data: {
      "studentUserId": studentUserId,
      "decision": decision,
    });
  }

  Future<void> decideOnStudentPost(int studentPostId, String decision) async {
    await client.post('/decisions/company/student-post', data: {
      "studentPostId": studentPostId,
      "decision": decision,
    });
  }

  Future<void> saveStudent(int studentUserId, bool saved) async {
    await client.post('/saves/company/student', data: {
      "studentUserId": studentUserId,
      "saved": saved,
    });
  }
}
