import 'package:equatable/equatable.dart';

enum AiMessageRole { user, assistant }

/// A single message in the AI travel chat.
class AiChatMessage extends Equatable {
  const AiChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.isLoading = false,
  });

  final String id;
  final AiMessageRole role;
  final String content;
  final DateTime timestamp;
  final bool isLoading;

  bool get isUser => role == AiMessageRole.user;

  AiChatMessage copyWith({
    String? id,
    AiMessageRole? role,
    String? content,
    DateTime? timestamp,
    bool? isLoading,
  }) {
    return AiChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [id, role, content, timestamp, isLoading];
}
