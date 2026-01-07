import 'package:flutter/material.dart';
import '../app_services.dart';
import 'messages_company_screen.dart';
import 'newpost_company_screen.dart';

class HomeCompanyScreen extends StatefulWidget {
  const HomeCompanyScreen({super.key});

  @override
  State<HomeCompanyScreen> createState() => _HomeCompanyScreenState();
}

class _HomeCompanyScreenState extends State<HomeCompanyScreen> {
  String? _selectedDepartment;
  bool _showFilter = false;

  bool _isLoading = true;
  String? _error;
  List<dynamic> _candidates = [];
  final Set<int> _savedCandidateIds = {};

  // Κατάστασή για double-tap καρδιές (κόκκινες καρδιές)
  final Set<int> _likedCandidateIds = {};

  final List<String> departments = [
    'Human Resources (HR)',
    'Marketing',
    'Public Relations (PR)',
    'Sales',
    'Legal Department',
    'IT',
    'Supply Chain',
    'Data Analytics',
    'Product Management',
    'Software Development',
  ];

  int _extractStudentId(dynamic candidate) {
    final raw = candidate['studentUserId'] ?? candidate['id'] ?? candidate['userId'];
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '0') ?? 0;
  }
  
  int? _extractStudentPostId(dynamic candidate) {
    final raw = candidate['studentPostId'] ?? candidate['postId'];
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '');
  }

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await AppServices.feed.getCompanyFeed();
      if (!mounted) return;
      _savedCandidateIds
        ..clear()
        ..addAll(data
            .where((c) => (c['saved'] ?? false) == true)
            .map<int>(_extractStudentId));
      setState(() {
        _candidates = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSave(int studentUserId, {int? studentPostId}) async {
    final wasSaved = _savedCandidateIds.contains(studentUserId);
    setState(() {
      if (wasSaved) {
        _savedCandidateIds.remove(studentUserId);
      } else {
        _savedCandidateIds.add(studentUserId);
      }
    });

    try {
      await AppServices.saves.setCompanySaveStudent(
        studentUserId,
        !wasSaved,
        studentPostId: studentPostId,
      );
    } catch (e) {
      setState(() {
        if (wasSaved) {
          _savedCandidateIds.add(studentUserId);
        } else {
          _savedCandidateIds.remove(studentUserId);
        }
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update save. Please retry.')),
      );
    }
  }

  Future<void> _decide(int studentUserId, String decision) async {
    final index = _candidates.indexWhere(
      (c) => _extractStudentId(c) == studentUserId,
    );
    dynamic removed;
    if (index != -1) {
      removed = _candidates[index];
      setState(() {
        _candidates.removeAt(index);
      });
    }

    try {
      await AppServices.feed.decideOnStudent(studentUserId, decision);
    } catch (e) {
      if (removed != null) {
        setState(() {
          _candidates.insert(index, removed);
        });
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not send decision. Please retry.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              // SafeArea μόνο για το header
              SafeArea(
                bottom: false,
                child: _buildStickyHeader(),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildBody(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Filter overlay
          if (_showFilter)
            Positioned(
              top: 85,
              right: 16,
              width: 200,
              child: _buildFilterDropdown(),
            ),

          // Bottom navigation FULL WIDTH
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    return Container(
      color: const Color(0xFFFAFD9F),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showFilter = !_showFilter;
                  });
                },
                child: const Icon(
                  Icons.filter_list,
                  color: Color(0xFF1B5E20),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Text(
                'Applications',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D3B1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: departments.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDepartment = departments[index];
                _showFilter = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Text(
                departments[index],
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontFamily: 'Trirong',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Text(
              'Failed to load feed:\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1B5E20),
                fontFamily: 'Trirong',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadFeed,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_candidates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            'No candidates available',
            style: TextStyle(
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _candidates.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildCandidateCard(_candidates[index]);
      },
    );
  }

  Widget _buildCandidateCard(dynamic candidate) {
    final int studentUserId = _extractStudentId(candidate);
    final int? studentPostId = _extractStudentPostId(candidate);
    final String name = (candidate['name'] ?? candidate['studentName'] ?? '') as String;
    final String university = (candidate['university'] ?? '') as String;
    final String department =
        (candidate['department'] ?? candidate['major'] ?? candidate['skills'] ?? '') as String;
    final String bio = (candidate['bio'] ?? candidate['description'] ?? '') as String;
    final String skills = (candidate['skills'] ?? '') as String;
    final bool isSaved = _savedCandidateIds.contains(studentUserId);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF0D3B1A),
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF1B5E20),
                    width: 1.5,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'Candidate',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B5E20),
                        fontFamily: 'Trirong',
                      ),
                    ),
                    if (university.isNotEmpty)
                      Text(
                        university,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1B5E20),
                          fontFamily: 'Trirong',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.image,
                  color: Color(0xFFBDBDBD),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (department.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          department,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B5E20),
                            fontFamily: 'Trirong',
                          ),
                        ),
                      ),
                    Text(
                      bio.isNotEmpty ? bio : 'No bio provided',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1B5E20),
                        fontFamily: 'Trirong',
                      ),
                    ),
                    if (skills.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        skills,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1B5E20),
                          fontFamily: 'Trirong',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: 'Pass',
                icon: const Icon(Icons.close, color: Color(0xFF1B5E20)),
                onPressed: () => _decide(studentUserId, 'PASS'),
              ),
              IconButton(
                tooltip: 'Like',
                icon: const Icon(Icons.check, color: Color(0xFF1B5E20)),
                onPressed: () => _decide(studentUserId, 'LIKE'),
              ),
              GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    if (_likedCandidateIds.contains(studentUserId)) {
                      _likedCandidateIds.remove(studentUserId);
                    } else {
                      _likedCandidateIds.add(studentUserId);
                    }
                  });
                },
                child: IconButton(
                  tooltip: 'Save',
                  icon: Icon(
                    _likedCandidateIds.contains(studentUserId)
                        ? Icons.favorite
                        : (isSaved ? Icons.favorite : Icons.favorite_outline),
                    color: _likedCandidateIds.contains(studentUserId)
                        ? Colors.red
                        : const Color(0xFF1B5E20),
                  ),
                  onPressed: () => _toggleSave(studentUserId, studentPostId: studentPostId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavIcon(Icons.home, () {
            // Already on Home screen
          }),
          _buildNavIcon(Icons.search, () {
            Navigator.pushNamed(context, '/search_company');
          }),
          _buildNavIcon(Icons.add, () {
            Navigator.pushNamed(context, '/newpost_company');
          }),
          _buildNavIcon(Icons.mail_outline, () {
            Navigator.pushNamed(context, '/messages_company');
          }),
          _buildNavIcon(Icons.person_outline, () {
            Navigator.pushNamed(context, '/profile_company');
          }),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: const Color(0xFF1B5E20),
        size: 24,
      ),
    );
  }
}
