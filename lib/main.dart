// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/chat_bloc.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart'; 
import 'theme/app_theme.dart';

void main() {
  runApp(BlocProvider(
    create: (_) => ChatBloc(),
    child: const ChatApp(),
  ));
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state.isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: const ChatScreen(),
          routes: {
            '/settings': (context) => const SettingsScreen(),
          },
        );
      },
    );
  }
}
