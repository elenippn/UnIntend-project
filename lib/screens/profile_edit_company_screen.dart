import 'package:flutter/material.dart';
import '../app_services.dart';

class ProfileEditCompanyScreen extends StatefulWidget {
  const ProfileEditCompanyScreen({super.key});

  @override
  State<ProfileEditCompanyScreen> createState() =>
      _ProfileEditCompanyScreenState();
}

class _ProfileEditCompanyScreenState extends State<ProfileEditCompanyScreen> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _internshipAdsController = TextEditingController();

  // Track which fields are being edited
  bool _showBioInput = false;
  bool _showInternshipAdsInput = false;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  String? _username;
  String? _companyBio;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

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
                  child: _buildContent(),
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

  Widget _buildContent() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Failed to load profile:\n$_error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Trirong'),
            ),
          ),
          ElevatedButton(onPressed: _loadProfile, child: const Text('Retry')),
        ],
      );
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        _buildUserEditInfo(),
        const SizedBox(height: 24),
        _buildAboutEditSection(),
        const SizedBox(height: 24),
      ],
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
    final displayUsername = (_username?.isNotEmpty ?? false)
        ? '@$_username'
        : '@username';

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
                    Text(
                      displayUsername,
                      style: const TextStyle(
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
                    controller: _companyNameController,
                    decoration: const InputDecoration(
                      hintText: 'Company Name',
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
              _buildEditableItem('Available Internship ads', _internshipAdsController, _showInternshipAdsInput,
                  () {
                setState(() {
                  _showInternshipAdsInput = !_showInternshipAdsInput;
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
          onPressed: (_isSaving || _isLoading) ? null : _saveProfile,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
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

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final me = await AppServices.auth.getMe();
      if (!mounted) return;
      setState(() {
        _username = (me['username'] ?? '') as String?;
        _companyNameController.text = (me['companyName'] ?? me['name'] ?? '') as String;
        _companyBio = (me['companyBio'] ?? me['bio'] ?? '') as String;
        _bioController.text = _companyBio ?? '';
        _showBioInput = true;
        _showInternshipAdsInput = true;
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

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    try {
      await AppServices.auth.updateMe(
        companyName: _companyNameController.text.trim(),
        companyBio: _bioController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _bioController.dispose();
    _internshipAdsController.dispose();
    super.dispose();
  }
}
