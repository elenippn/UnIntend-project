import 'package:flutter/material.dart';
import 'screens/loadscreen.dart';
import 'screens/signup_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/home_student_screen.dart';
import 'screens/newpost_student_screen.dart';
import 'screens/search_student_screen.dart';
import 'screens/messages_student_screen.dart';
import 'screens/profile_student_screen.dart';
import 'screens/signup_company_screen.dart';
import 'screens/home_company_screen.dart';
import 'screens/messages_company_screen.dart';
import 'screens/message_chat_company_screen.dart';
import 'screens/profile_company_screen.dart';
import 'screens/profile_edit_company_screen.dart';
import 'screens/newpost_company_screen.dart';
import 'screens/search_company_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UnIntern',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFAFD9F)),
        useMaterial3: true,
        fontFamily: 'Trirong',
      ),
      home: const LoadScreen(),
    
      routes: {
        '/loadscreen': (context) => const LoadScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/signin': (context) => const SignInScreen(),
        '/home_student': (context) => const HomeStudentScreen(),
        '/newpost_student': (context) => const NewPostStudentScreen(),
        '/search_student': (context) => const SearchStudentScreen(),
        '/messages_student': (context) => const MessagesStudentScreen(),
        '/profile_student': (context) => const ProfileStudentScreen(),
        '/signup_company': (context) => const SignUpCompanyScreen(),
        '/home_company': (context) => const HomeCompanyScreen(),
        '/search_company': (context) => const SearchCompanyScreen(),
        '/newpost_company': (context) => const NewPostCompanyScreen(),
        '/messages_company': (context) => const MessagesCompanyScreen(),
        '/message_chat_company': (context) => const ChatCompanyScreen(conversationId: '', title: '', subtitle: ''),
        '/profile_company': (context) => const ProfileCompanyScreen(),
        '/profile_edit_company': (context) => const ProfileEditCompanyScreen(),      },
    );
  }
}

