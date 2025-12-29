import 'package:flutter/material.dart';

class ProfileEditStudentScreen extends StatefulWidget {
  const ProfileEditStudentScreen({super.key});

  @override
  State<ProfileEditStudentScreen> createState() =>
      _ProfileEditStudentScreenState();
}

class _ProfileEditStudentScreenState extends State<ProfileEditStudentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _studiesController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  // Track which fields are being edited
  bool _showBioInput = false;
  bool _showStudiesInput = false;
  bool _showExperienceInput = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(bottom: false, child: _buildHeader()),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildUserEditInfo(),
                      const SizedBox(height: 24),
                      _buildAboutEditSection(),
                      const SizedBox(height: 16),
                      _buildPostsEditSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildSaveButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          const SizedBox(height: 6),
          const Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF1B5E20),
              fontFamily: 'Trirong',
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildUserEditInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFC9D3C9),
              border: Border.all(
                color: const Color(0xFF1B5E20),
                width: 2,
              ),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: Upload image
                },
                child: const Icon(
                  Icons.add_a_photo,
                  size: 32,
                  color: Color(0xFF1B5E20),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                const Text(
                  '@username',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1B5E20),
                    fontFamily: 'Trirong',
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9D3C9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Trirong',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC9D3C9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      hintText: 'Surname',
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Trirong',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutEditSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF1B5E20),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildEditableItem('Bio description', _bioController, _showBioInput,
                  () {
                setState(() {
                  _showBioInput = !_showBioInput;
                });
              }),
              const SizedBox(height: 16),
              _buildEditableItem('Studies', _studiesController, _showStudiesInput,
                  () {
                setState(() {
                  _showStudiesInput = !_showStudiesInput;
                });
              }),
              const SizedBox(height: 16),
              _buildEditableItem(
                  'Experience', _experienceController, _showExperienceInput, () {
                setState(() {
                  _showExperienceInput = !_showExperienceInput;
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableItem(String label, TextEditingController controller,
      bool isExpanded, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              Icon(Icons.add, color: const Color(0xFF1B5E20), size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
            ],
          ),
        ),
        if (isExpanded)
          Column(
            children: [
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFC9D3C9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter $label',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Trirong',
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPostsEditSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 280,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF1B5E20),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Posts',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  // TODO: Delete posts
                },
                child: const Icon(
                  Icons.delete,
                  color: Color(0xFF1B5E20),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            padding:
                const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            // TODO: Save profile changes
            Navigator.pop(context);
          },
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'Trirong',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _bioController.dispose();
    _studiesController.dispose();
    _experienceController.dispose();
    super.dispose();
  }
}
