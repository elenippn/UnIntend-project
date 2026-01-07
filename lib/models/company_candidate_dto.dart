class CompanyCandidateDto {
  final int studentUserId;
  final int? studentPostId;
  final String name;
  final String? university;
  final String? department;
  final String? bio;
  final String? skills;
  final bool saved;

  // imageUrl: student profile post image (card)
  final String? imageUrl;

  // studentProfileImageUrl: student's user profile avatar image
  final String? studentProfileImageUrl;

  const CompanyCandidateDto({
    required this.studentUserId,
    required this.studentPostId,
    required this.name,
    required this.university,
    required this.department,
    required this.bio,
    required this.skills,
    required this.saved,
    required this.imageUrl,
    required this.studentProfileImageUrl,
  });

  factory CompanyCandidateDto.fromJson(Map<String, dynamic> json) {
    final rawStudentUserId = json['studentUserId'] ?? json['id'] ?? json['userId'];
    final studentUserId = rawStudentUserId is int
        ? rawStudentUserId
        : int.tryParse(rawStudentUserId?.toString() ?? '') ?? 0;

    final rawStudentPostId = json['studentPostId'] ?? json['postId'];
    final studentPostId = rawStudentPostId is int
        ? rawStudentPostId
        : int.tryParse(rawStudentPostId?.toString() ?? '');

    final rawName = (json['name'] ?? json['studentName'] ?? json['fullName'] ?? '') as String;

    return CompanyCandidateDto(
      studentUserId: studentUserId,
      studentPostId: studentPostId,
      name: rawName,
      university: json['university'] as String?,
      department: (json['department'] ?? json['major'] ?? json['skills']) as String?,
      bio: (json['bio'] ?? json['description']) as String?,
      skills: json['skills'] as String?,
      saved: (json['saved'] ?? false) == true,
      imageUrl: json['imageUrl'] as String?,
      studentProfileImageUrl: json['studentProfileImageUrl'] as String?,
    );
  }
}
