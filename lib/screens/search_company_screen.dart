import 'package:flutter/material.dart';
import 'dart:async';
import '../app_services.dart';

class SearchCompanyScreen extends StatefulWidget {
  const SearchCompanyScreen({super.key});

  @override
  State<SearchCompanyScreen> createState() => _SearchCompanyScreenState();
}

class _SearchCompanyScreenState extends State<SearchCompanyScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Timer? _debounceTimer;
  
  List<dynamic> _allCandidates = [];
  List<dynamic> _filteredCandidates = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAllCandidates();
  }

  Future<void> _loadAllCandidates() async {
    setState(() {
      _error = null;
    });

    try {
      final candidates = await AppServices.feed.getCompanyFeed();
      if (!mounted) return;
      setState(() {
        _allCandidates = candidates;
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
        _filteredCandidates = [];
      });
      return;
    }

    // Start new timer - search after 500ms of inactivity
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final lowerQuery = query.toLowerCase();
      setState(() {
        _filteredCandidates = _allCandidates.where((candidate) {
          final firstName = (candidate['firstName'] ?? '').toString().toLowerCase();
          final lastName = (candidate['lastName'] ?? '').toString().toLowerCase();
          final name = (candidate['name'] ?? '').toString().toLowerCase();
          final bio = (candidate['bio'] ?? '').toString().toLowerCase();
          return firstName.contains(lowerQuery) ||
              lastName.contains(lowerQuery) ||
              name.contains(lowerQuery) ||
              bio.contains(lowerQuery);
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

          // Navbar
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
            'Search for students',
            style: TextStyle(
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    if (_error != null && _allCandidates.isEmpty) {
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

    if (_filteredCandidates.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(
            'No students found',
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
      itemCount: _filteredCandidates.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildSearchResultCard(_filteredCandidates[index]);
      },
    );
  }

  Widget _buildSearchResultCard(dynamic result) {
    final String name = result['name'] ?? result['firstName'] ?? 'Student';
    final String? bio = result['bio'];
    final String? university = result['university'];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF1B5E20),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
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
                size: 28,
                color: Color(0xFF1B5E20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                    fontFamily: 'Trirong',
                  ),
                ),
                if (university != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    university,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1B5E20),
                      fontFamily: 'Trirong',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (bio != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    bio,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF1B5E20),
                      fontFamily: 'Trirong',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
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
            Navigator.pushNamed(context, '/home_company');
          }),
          _buildNavIcon(Icons.search, () {
            // Already on Search screen
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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
}
