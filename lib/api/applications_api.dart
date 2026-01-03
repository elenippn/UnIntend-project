import 'api_client.dart';

class ApplicationsApi {
  final ApiClient client;
  ApplicationsApi(this.client);

  Future<List<dynamic>> listApplications() async {
    final res = await client.get('/applications');
    return res.data as List<dynamic>;
  }
}
