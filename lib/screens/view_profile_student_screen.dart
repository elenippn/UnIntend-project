import 'package:flutter/material.dart';
import '../app_services.dart';

class ViewProfileStudentScreen extends StatefulWidget {
  final Map student;

  const ViewProfileStudentScreen({super.key, required this.student});

  @override
  State<ViewProfileStudentScreen> createState() => _ViewProfileStudentScreenState();
}

class _ViewProfileStudentScreenState extends State<ViewProfileStudentScreen> {
  List<dynamic> _posts = const [];
  bool _loadingPosts = false;
  String? _postsError;

  @override
  void initState() {
    super.initState();
    _maybeLoadPosts();
  }

  Future<void> _maybeLoadPosts() async {
    final int? studentUserId = _extractStudentUserId(widget.student);
    if (studentUserId == null) return;
    setState(() => _loadingPosts = true);
    try {
      final res = await AppServices.posts.listProfilePostsForStudent(studentUserId);
      if (!mounted) return;
      setState(() {
        _posts = res;
        _loadingPosts = false;
        _postsError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingPosts = false;
        _postsError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
    final String username = (student['username'] ?? '') as String;
    final String rawName = (
      student['name'] ??
      student['studentName'] ??
      student['fullName'] ??
      ''
    ) as String;
    final String firstName = (student['firstName'] ?? '') as String;
    final String lastName = (student['lastName'] ?? '') as String;
    final String displayName = rawName.isNotEmpty
        ? rawName
        : '$firstName $lastName'.trim();
    final String university = (student['university'] ?? '') as String;
    final String department = (student['department'] ?? student['major'] ?? '') as String;
    final String bio = (student['bio'] ?? student['description'] ?? '') as String;
    final String experience = (student['experience'] ?? student['skills'] ?? '') as String;
    final List<dynamic> posts =
        _posts.isNotEmpty ? _posts : (student['posts'] ?? student['profilePosts'] ?? const []) as List<dynamic>;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(bottom: false, child: _buildHeader(context)),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16, top: 24),
                  child: Column(
                    children: [
                      _buildUserInfo(displayName, username),
                      const SizedBox(height: 20),
                      _buildCard('About/Bio', bio.isNotEmpty ? bio : 'No bio provided'),
                      const SizedBox(height: 12),
                      _buildCard(
                        'Studies',
                        _joinNonEmpty([
                          university,
                          department,
                        ], separator: '\n'),
                      ),
                      const SizedBox(height: 12),
                      _buildCard(
                        'Experience',
                        experience.isNotEmpty ? experience : 'No experience provided',
                      ),
                      const SizedBox(height: 12),
                      if (_loadingPosts)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: CircularProgressIndicator(),
                        )
                      else if (_postsError != null)
                        _buildCard('Posts', 'Could not load posts: $_postsError')
                      else
                        _buildPosts(posts),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPosts(List<dynamic> posts) {
    if (posts.isEmpty) {
      return _buildCard('Posts', 'No posts available');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Posts',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...posts.map((p) {
          final String title = (p['title'] ?? p['name'] ?? 'Post') as String;
          final String description = (p['description'] ?? '') as String;
          return _buildPostCard(title, description);
        }).toList(),
      ],
    );
  }

  Widget _buildPostCard(String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1B5E20), width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description.isNotEmpty ? description : 'No description',
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontFamily: 'Trirong',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFD9F),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1B5E20),
              size: 28,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'UnIntern',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
            ),
          ),
          const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String name, String username) {
    final String displayUsername = username.isNotEmpty ? '@$username' : '@username';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF1B5E20),
              width: 2,
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF1B5E20),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                displayUsername,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name.isNotEmpty ? name : 'Student',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String body) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1B5E20), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body.isNotEmpty ? body : 'Not provided',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Trirong',
            ),
          ),
        ],
      ),
    );
  }

  String _joinNonEmpty(List<String> items, {String separator = ', '}) {
    final filtered = items.where((e) => e.isNotEmpty).toList();
    return filtered.isNotEmpty ? filtered.join(separator) : 'Not provided';
  }

  int? _extractStudentUserId(Map candidate) {
    final keys = ['studentUserId', 'userId', 'id'];
    for (final k in keys) {
      final v = candidate[k];
      if (v is int) return v;
      if (v is String) {
        final parsed = int.tryParse(v);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}
