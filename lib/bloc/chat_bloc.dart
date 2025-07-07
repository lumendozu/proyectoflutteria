// lib/bloc/chat_bloc.dart
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';

// Events
abstract class ChatEvent {}

class SendMessage extends ChatEvent {
  final String text;
  SendMessage(this.text);
}

class ToggleTheme extends ChatEvent {}

class ClearChat extends ChatEvent {}

// States
class ChatState {
  final List<Message> messages;
  final bool isDark;
  final bool isLoading;

  ChatState({
    required this.messages,
    required this.isDark,
    this.isLoading = false,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isDark,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isDark: isDark ?? this.isDark,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String apiKey = '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';
  final String model = 'mistralai/mistral-7b-instruct';

  ChatBloc() : super(ChatState(messages: [], isDark: true)) {
    on<SendMessage>(_onSendMessage);
    on<ToggleTheme>((event, emit) {
      emit(state.copyWith(isDark: !state.isDark));
    });
    on<ClearChat>((event, emit) {
      emit(state.copyWith(messages: []));
    });
  }

  Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    if (event.text.trim().isEmpty) return;

    final userMessage = Message(
      content: event.text,
      role: 'user',
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<Message>.from(state.messages)..add(userMessage);
    emit(state.copyWith(messages: updatedMessages, isLoading: true));

    try {
      final messagesForAPI = updatedMessages.map((msg) => msg.toJson()).toList();
      
      final res = await http.post(
        Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': messagesForAPI,
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      String reply;
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        reply = data['choices'][0]['message']['content'];
      } else {
        reply = 'Error: No se pudo obtener respuesta del servidor';
      }

      final assistantMessage = Message(
        content: reply,
        role: 'assistant',
        timestamp: DateTime.now(),
      );

      final finalMessages = List<Message>.from(updatedMessages)..add(assistantMessage);
      emit(state.copyWith(messages: finalMessages, isLoading: false));
    } catch (e) {
      final errorMessage = Message(
        content: 'Error: No se pudo conectar con el servidor',
        role: 'assistant',
        timestamp: DateTime.now(),
      );
      final finalMessages = List<Message>.from(updatedMessages)..add(errorMessage);
      emit(state.copyWith(messages: finalMessages, isLoading: false));
    }
  }
}
