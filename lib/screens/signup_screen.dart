import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedRole;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              _buildDropdown(),
              const SizedBox(height: 24),
              _buildContinueButton(),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/signin');
                },
                child: const Text(
                  'I already have an account',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF1B5E20),
                    fontFamily: 'Trirong',
                    decoration: TextDecoration.underline,
                  ),
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

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF1B5E20),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: DropdownButton<String>(
        value: _selectedRole,
        hint: const Text(
          'User Role',
          style: TextStyle(
            color: Color(0xFF1B5E20),
            fontSize: 12,
            fontFamily: 'Trirong',
          ),
        ),
        isExpanded: true,
        underline: Container(),
        dropdownColor: const Color(0xFF6B9B5F),
        selectedItemBuilder: (BuildContext context) {
          return ['Student', 'Company'].map<Widget>((String value) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1B5E20),
                  fontSize: 12,
                  fontFamily: 'Trirong',
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList();
        },
        items: ['Student', 'Company'].map((String value) {
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
        onChanged: (String? value) {
          setState(() {
            _selectedRole = value;
          });
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
        // Navigate based on selected role
        if (_selectedRole == 'Student') {
          Navigator.of(context).pushNamed('/home_student');
        }
        // TODO: Add navigation for Company and Admin roles
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
