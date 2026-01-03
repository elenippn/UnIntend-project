import 'package:flutter/material.dart';
import '../app_services.dart'; 

class SavedListingsCompanyScreen extends StatefulWidget {
  const SavedListingsCompanyScreen({super.key});

  @override
  State<SavedListingsCompanyScreen> createState() =>
      _SavedListingsCompanyScreenState();
}

class _SavedListingsCompanyScreenState extends State<SavedListingsCompanyScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _saved = [];

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await AppServices.saves.listCompanySavedStudents();
      if (!mounted) return;
      setState(() {
        _saved = data;
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

  Future<void> _removeFromSaved(int studentUserId) async {
    final idx = _saved.indexWhere((x) => (x['studentUserId'] as int) == studentUserId);
    if (idx == -1) return;
    final removed = _saved[idx];

    setState(() => _saved.removeAt(idx));

    try {
      await AppServices.saves.setCompanySaveStudent(studentUserId, false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from saved')),
      );
    } catch (e) {
      setState(() => _saved.insert(idx, removed));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not remove: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFD9F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Saved Candidates',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Trirong',
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load saved candidates:\n$_error',
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Trirong'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadSaved,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_saved.isEmpty) return _buildEmptyState();

    return RefreshIndicator(
      onRefresh: _loadSaved,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _saved.length,
        itemBuilder: (context, index) {
          final c = _saved[index];

          // Expected from backend (we will implement):
          // studentUserId, name, university, major/department, description/bio
          final int studentUserId = c['studentUserId'] as int;
          final String name = (c['name'] ?? '') as String;
          final String university = (c['university'] ?? '') as String;
          final String major = (c['major'] ?? c['department'] ?? '') as String;
          final String description = (c['description'] ?? c['bio'] ?? '') as String;

          return _buildCandidateCard(
            name: name,
            university: university,
            major: major,
            description: description,
            onUnsave: () => _removeFromSaved(studentUserId),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Saved Candidates',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: 'Trirong',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add candidates to your favorites to see them here',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontFamily: 'Trirong',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard({
    required String name,
    required String university,
    required String major,
    required String description,
    required VoidCallback onUnsave,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                          fontFamily: 'Trirong',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        major,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontFamily: 'Trirong',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.favorite, color: Color(0xFF1B5E20)),
                  onPressed: onUnsave,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.school, size: 16, color: Color(0xFF1B5E20)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    university,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: 'Trirong',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontFamily: 'Trirong',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // TODO: open candidate profile screen
                    },
                    child: const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Trirong',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF1B5E20)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // TODO: message candidate (needs conversationId endpoint)
                    },
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        color: Color(0xFF1B5E20),
                        fontSize: 12,
                        fontFamily: 'Trirong',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
