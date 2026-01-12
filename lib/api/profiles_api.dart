import 'api_client.dart';
import '../models/student_profile_dto.dart';

class ProfilesApi {
  final ApiClient client;
  ProfilesApi(this.client);

  Future<StudentProfileDto> getStudentProfile(int studentUserId) async {
    final res = await client.get('/profiles/students/$studentUserId');
    return StudentProfileDto.fromJson(
        Map<String, dynamic>.from(res.data as Map));
  }
}
