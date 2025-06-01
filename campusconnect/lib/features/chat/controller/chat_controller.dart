import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/chat/repository/chat_repository.dart';
import 'package:campusconnect/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ChatControllerProvider = StateNotifierProvider<ChatController, bool>((
  ref,
) {
  final chatRepository = ref.watch(ChatRepositoryProvider);
  return ChatController(chatrepository: chatRepository, ref: ref);
});

final lastMessagesProvider = StreamProvider.family<List<Message>, String>((
  ref,
  userId,
) {
  return ref.watch(ChatControllerProvider.notifier).getLastMessages(userId);
});

final userChatsProvider = StreamProvider.family((ref, String userId) {
  return ref.watch(ChatRepositoryProvider).getUserChats(userId);
});

class ChatController extends StateNotifier<bool> {
  final ChatRepository _chatRepository;
  final Ref _ref;

  ChatController({required ChatRepository chatrepository, required Ref ref})
    : _chatRepository = chatrepository,
      _ref = ref,
      super(false);

  void sendMessages(String chatId, Message msg, BuildContext context) async {
    state = true;
    final res = await _chatRepository.sendMessage(chatId, msg);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Message>> getMessage(String chatId) {
    return _chatRepository.getMessages(chatId);
  }

  void markMessageAsRead(
    String chatId,
    String messageId,
    BuildContext context,
  ) async {
    final res = await _chatRepository.markAsRead(chatId, messageId);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void editMessage(
    String chatId,
    String messageId,
    String newText,
    BuildContext context,
  ) async {
    final res = await _chatRepository.editMessage(chatId, messageId, newText);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Stream<List<Message>> getLastMessages(String userId) {
    return _chatRepository.getLastMessagesForUser(userId);
  }

  void deleteMessage(
    String chatId,
    String messageId,
    BuildContext context,
  ) async {
    final res = await _chatRepository.deleteMessage(chatId, messageId);
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void reactToMessage(
    String chatId,
    String messageId,
    String reaction,
    BuildContext context,
  ) async {
    final res = await _chatRepository.reactToMessage(
      chatId,
      messageId,
      reaction,
    );
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  void setTyping(String chatId, String userId, bool isTyping) async {
    await _chatRepository.setTyping(chatId, userId, isTyping);
  }

  Stream<bool> getTyping(String chatId, String userId) {
    return _chatRepository.getTyping(chatId, userId);
  }
}
