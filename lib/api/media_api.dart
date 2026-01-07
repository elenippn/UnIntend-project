import 'dart:io';

import 'package:dio/dio.dart';

import 'api_client.dart';

class MediaApi {
  final ApiClient client;
  MediaApi(this.client);

  Future<String?> uploadMyProfileImage(File file) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final res = await client.postMultipart('/media/me/profile-image', data: form);
    final data = Map<String, dynamic>.from(res.data as Map);
    return data['profileImageUrl'] as String?;
  }

  Future<String?> uploadInternshipPostImage(int postId, File file) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final res = await client.postMultipart('/media/internship-posts/$postId/image', data: form);
    final data = Map<String, dynamic>.from(res.data as Map);
    return data['imageUrl'] as String?;
  }

  Future<String?> uploadStudentProfilePostImage(int studentPostId, File file) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final res =
        await client.postMultipart('/media/student-profile-posts/$studentPostId/image', data: form);
    final data = Map<String, dynamic>.from(res.data as Map);
    return data['imageUrl'] as String?;
  }

  Future<String?> uploadProfilePostImage(int postId, File file) async {
    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final res = await client.postMultipart('/media/profile-posts/$postId/image', data: form);
    final data = Map<String, dynamic>.from(res.data as Map);
    return data['imageUrl'] as String?;
  }
}
