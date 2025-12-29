import 'package:flutter/material.dart';

class SignUpCompanyScreen extends StatefulWidget {
  const SignUpCompanyScreen({super.key});

  @override
  State<SignUpCompanyScreen> createState() => _SignUpCompanyScreenState();
}

class _SignUpCompanyScreenState extends State<SignUpCompanyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  String _selectedRole = 'Company';

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFD9F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            children: [
              const Text(
                'UnIntern',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign-Up',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField('Name', _nameController),
              const SizedBox(height: 12),
              _buildTextField('Surname', _surnameController),
              const SizedBox(height: 12),
              _buildTextField('Username', _usernameController),
              const SizedBox(height: 12),
              _buildTextField('Email', _emailController),
              const SizedBox(height: 12),
              _buildTextField('Password', _passwordController, isPassword: true),
              const SizedBox(height: 12),
              _buildTextField('Re-write Password', _confirmPasswordController,
                  isPassword: true),
              const SizedBox(height: 12),
              _buildTextField('Company', _companyController),
              const SizedBox(height: 12),
              _buildRoleDropdown(),
              const SizedBox(height: 24),
              _buildContinueButton(),
              const SizedBox(height: 12),
              const Text(
                'I already have an account',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1B5E20),
                  fontFamily: 'Trirong',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontFamily: 'Trirong'),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 12,
          fontFamily: 'Trirong',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFF1B5E20),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFF1B5E20),
            width: 1.5,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF1B5E20),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: _selectedRole,
        isExpanded: true,
        underline: Container(),
        dropdownColor: const Color(0xFF6B9B5F).withOpacity(0.7),
        items: ['Company', 'Student'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFFFAFD9F),
                fontSize: 12,
                fontFamily: 'Trirong',
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedRole = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        side: const BorderSide(
          color: Color(0xFF1B5E20),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 12,
        ),
      ),
      onPressed: () {
        // Handle company sign up
      },
      child: const Text(
        'Continue',
        style: TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Trirong',
        ),
      ),
    );
  }
}
