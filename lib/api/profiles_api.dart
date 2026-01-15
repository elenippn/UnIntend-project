import 'api_client.dart';
import '../models/student_profile_dto.dart';
import '../models/auth_me_dto.dart';

class ProfilesApi {
  final ApiClient client;
  ProfilesApi(this.client);

  Future<StudentProfileDto> getStudentProfile(int studentUserId) async {
    final res = await client.get('/profiles/students/$studentUserId');
    return StudentProfileDto.fromJson(
        Map<String, dynamic>.from(res.data as Map));
  }

  Future<AuthMeDto?> getCompanyProfile(int companyUserId) async {
    try {
      // Try different possible endpoints for company profile
      final endpoints = [
        '/profiles/companies/$companyUserId',
        '/profiles/company/$companyUserId', 
        '/companies/$companyUserId',
        '/users/$companyUserId'
      ];
      
      for (final endpoint in endpoints) {
        try {
          final res = await client.get(endpoint);
          return AuthMeDto.fromJson(
              Map<String, dynamic>.from(res.data as Map));
        } catch (e) {
          // Try next endpoint
          continue;
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
}
