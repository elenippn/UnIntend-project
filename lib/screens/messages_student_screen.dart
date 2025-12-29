import 'package:flutter/material.dart';
import 'message_chat_screen.dart';

class MessagesStudentScreen extends StatefulWidget {
  const MessagesStudentScreen({super.key});

  @override
  State<MessagesStudentScreen> createState() => _MessagesStudentScreenState();
}

class _MessagesStudentScreenState extends State<MessagesStudentScreen> {
  String? _selectedFilter;
  bool _showFilter = false;

  final List<String> filters = [
    'All',
    'Accepted',
    'Declined',
    'Pending',
    'Other',
  ];

  final List<Map<String, String>> messages = [
    {
      'company': 'Company Name 1',
      'status': 'Pending...',
      'type': 'Pending',
    },
    {
      'company': 'Company Name 2',
      'status': 'Ready to connect?',
      'type': 'Accepted',
    },
    {
      'company': 'Company Name 3',
      'status': 'Declined',
      'type': 'Declined',
    },
    {
      'company': 'Company Name 4',
      'status': 'Last sent message',
      'type': 'Other',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Content
          Column(
            children: [
              // ✅ SafeArea μόνο για το header (όπως Home/Search)
              SafeArea(
                bottom: false,
                child: _buildStickyHeader(),
              ),

              Expanded(
                child: SingleChildScrollView(
                  // ✅ χώρο για να μη “κάθονται” τα items κάτω από το navbar
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: messages.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _buildMessageItem(messages[index]);
                          },
                        ),
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

          // ✅ Bottom navigation FULL WIDTH όπως στο Home (χωρίς SafeArea μέσα)
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
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
                'Messages',
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
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filters[index];
                _showFilter = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                filters[index],
                style: const TextStyle(
                  fontSize: 13,
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

Widget _buildMessageItem(Map<String, String> message) {
  return GestureDetector(
    onTap: () {
      // ✅ ΕΔΩ είναι το (1)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            conversationId: message['company']!, // προσωρινό id
            title: message['company']!,
            subtitle: '@Username1',
          ),
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF1B5E20),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
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
                size: 20,
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
                  message['company']!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                    fontFamily: 'Trirong',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message['status']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: message['type'] == 'Declined'
                        ? Colors.red
                        : const Color(0xFF1B5E20),
                    fontFamily: 'Trirong',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.circle,
            size: 8,
            color: Color(0xFF1B5E20),
          ),
        ],
      ),
    ),
  );
}


  // ✅ Navbar ίδιο με Home (χωρίς SafeArea wrapper)
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
            Navigator.pushNamed(context, '/search_student');
          }),
          _buildNavIcon(Icons.add, () {
            Navigator.pushNamed(context, '/newpost_student');
          }),
          _buildNavIcon(Icons.mail_outline, () {
            // already on Messages screen
          }),
          _buildNavIcon(Icons.person_outline, () {
            Navigator.pushNamed(context, '/profile_student');
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
