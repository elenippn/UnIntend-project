import 'package:flutter/material.dart';
import 'dart:async';
import '../app_services.dart';

class SearchStudentScreen extends StatefulWidget {
  const SearchStudentScreen({super.key});

  @override
  State<SearchStudentScreen> createState() => _SearchStudentScreenState();
}

class _SearchStudentScreenState extends State<SearchStudentScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounceTimer;
  
  List<dynamic> _allPosts = [];
  List<dynamic> _filteredPosts = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllPosts();
  }

  Future<void> _loadAllPosts() async {
    setState(() {
      _error = null;
    });

    try {
      final posts = await AppServices.feed.getStudentFeed();
      if (!mounted) return;
      setState(() {
        _allPosts = posts;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  void _performSearch(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isEmpty) {
      setState(() {
        _filteredPosts = [];
      });
      return;
    }

    // Start new timer - search after 500ms of inactivity
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final lowerQuery = query.toLowerCase();
      setState(() {
        _filteredPosts = _allPosts.where((post) {
          final title = (post['title'] ?? '').toString().toLowerCase();
          final description = (post['description'] ?? '').toString().toLowerCase();
          final companyName = (post['companyName'] ?? '').toString().toLowerCase();
          return title.contains(lowerQuery) ||
              description.contains(lowerQuery) ||
              companyName.contains(lowerQuery);
        }).toList();
      });
    });
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
              SafeArea(bottom: false, child: _buildStickyHeader()),
              Expanded(
                child: SingleChildScrollView(
                  // ✅ ίδιο concept με Home: αφήνουμε “χώρο” για να μη καλύπτεται
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildSearchResults(),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ✅ Navbar ίδιο με Home (Positioned full width)
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

  Widget _buildSearchResults() {
    if (!_isSearching) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            'Search for internships or companies',
            style: TextStyle(
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    if (_error != null && _allPosts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            'Error loading data',
            style: const TextStyle(
              color: Colors.red,
              fontFamily: 'Trirong',
            ),
          ),
        ),
      );
    }

    if (_filteredPosts.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            'No results found',
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
      itemCount: _filteredPosts.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildSearchResultCard(_filteredPosts[index]);
      },
    );
  }

  Widget _buildSearchResultCard(dynamic result) {
    final String title = result['title'] ?? result['companyName'] ?? 'Post';
    final String description = result['description'] ?? '';
    final String? location = result['location'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF1B5E20),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
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
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (location != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: Color(0xFF1B5E20),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF1B5E20),
                      fontFamily: 'Trirong',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
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
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _isSearching = value.isNotEmpty);
                      _performSearch(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Trirong',
                        fontSize: 13,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF1B5E20),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF1B5E20),
                      fontFamily: 'Trirong',
                    ),
                  ),
                ),
              ),
              if (_isSearching)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _isSearching = false);
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B5E20),
                        fontFamily: 'Trirong',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ✅ ΑΚΡΙΒΩΣ ίδιο navbar code με Home
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
            Navigator.pushNamed(context, '/home_student');
          }),
          _buildNavIcon(Icons.search, () {
            // Already on Search screen
          }),
          _buildNavIcon(Icons.add, () {
            Navigator.pushNamed(context, '/newpost_student');
          }),
          _buildNavIcon(Icons.mail_outline, () {
            Navigator.pushNamed(context, '/messages_student');
          }),
          _buildNavIcon(Icons.person_outline, () {
            Navigator.pushNamed(context, '/profile_student');
          }),
        ],
      ),
    );
  }

  // ✅ ίδιο helper όπως στο Home (για να ταιριάξει 100%)
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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
