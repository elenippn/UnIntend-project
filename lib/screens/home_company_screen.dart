import 'package:flutter/material.dart';
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

  final List<Map<String, String>> applications = [
    {
      'username': 'Username 1',
      'description': 'Application Description',
    },
    {
      'username': 'Username 2',
      'description': 'Application Description',
    },
    {
      'username': 'Username 3',
      'description': 'Application Description',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 140),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: applications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      return _buildApplicationCard(applications[index]);
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Sticky header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildStickyHeader(),
          ),
          // Filter overlay
          if (_showFilter)
            Positioned(
              top: 95,
              right: 16,
              width: 200,
              child: _buildFilterDropdown(),
            ),
          // Bottom navigation
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

  Widget _buildApplicationCard(Map<String, String> application) {
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
              Text(
                application['username']!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
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
                    Text(
                      application['description']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1B5E20),
                        fontFamily: 'Trirong',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        3,
                        (i) => Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                              right: i < 2 ? 4 : 0,
                            ),
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.favorite_outline,
              color: Color(0xFF1B5E20),
              size: 20,
            ),
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
