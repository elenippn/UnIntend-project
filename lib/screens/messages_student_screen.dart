import 'package:flutter/material.dart';
import '../app_services.dart';
import 'message_chat_screen.dart';

class MessagesStudentScreen extends StatefulWidget {
  const MessagesStudentScreen({super.key});

  @override
  State<MessagesStudentScreen> createState() => _MessagesStudentScreenState();
}

class _MessagesStudentScreenState extends State<MessagesStudentScreen> {
  Set<String> _selectedFilters = {};
  bool _showFilter = false;

  bool _isLoading = true;
  String? _error;
  List<dynamic> _applications = [];

  final List<String> filters = [
    'All',
    'ACCEPTED',
    'DECLINED',
    'PENDING',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await AppServices.applications.listApplications();
      if (!mounted) return;
      setState(() {
        _applications = _dedupByConversationId(data);
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

  List<dynamic> _dedupByConversationId(List<dynamic> raw) {
    final Map<String, dynamic> byKey = {};
    for (final item in raw) {
      final cidRaw = item['conversationId'];
      final cid = cidRaw is int ? cidRaw : int.tryParse(cidRaw?.toString() ?? '');
      // use conversationId if present, else fall back to otherPartyName to avoid duplicates
      final key = cid != null
          ? 'cid_$cid'
          : 'party_${(item['otherPartyName'] ?? item['company'] ?? '').toString()}';
      if (key.trim().isEmpty) continue;
      byKey[key] = item; // keep last occurrence
    }
    return byKey.values.toList();
  }

  List<dynamic> get _filteredApplications {
    if (_selectedFilters.isEmpty) {
      return _applications;
    }
    return _applications.where((a) {
      final status = (a['status'] ?? '').toString().toUpperCase();
      return _selectedFilters.contains(status);
    }).toList();
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
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilters.contains(filter);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (filter == 'All') {
                  // "All" clears all selections
                  _selectedFilters.clear();
                } else {
                  if (isSelected) {
                    _selectedFilters.remove(filter);
                  } else {
                    // Remove "All" if selecting a specific filter
                    _selectedFilters.remove('All');
                    _selectedFilters.add(filter);
                  }
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Trirong',
                      ),
                    ),
                  ),
                ],
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
            conversationId: int.parse(message['conversationId']!),
            title: message['company']!,
            subtitle: message['status']!,
            canSend: message['status']!.toUpperCase() == 'ACCEPTED',
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
                  (message['lastMessage']?.isNotEmpty ?? false)
                      ? message['lastMessage']!
                      : message['status']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: (message['type'] ?? '').toUpperCase() == 'DECLINED'
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

    Widget _buildBody() {
      if (_isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_error != null) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                'Failed to load applications:\n$_error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Trirong'),
              ),
            ),
            ElevatedButton(onPressed: _loadApplications, child: const Text('Retry')),
          ],
        );
      }

      final filtered = _filteredApplications;

      if (filtered.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text(
              'No messages',
              style: TextStyle(fontFamily: 'Trirong'),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filtered.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = filtered[index] as Map;
          final status = (item['status'] ?? '') as String;
          final company = (item['otherPartyName'] ?? item['company'] ?? 'Company') as String;
          final lastMessage = (item['lastMessage'] ?? '') as String;
          final conversationId = (item['conversationId'] as int?) ?? 0;

          return _buildMessageItem({
            'company': company,
            'status': status,
            'type': status,
            'conversationId': conversationId.toString(),
            'lastMessage': lastMessage,
          });
        },
      );
    }
}
