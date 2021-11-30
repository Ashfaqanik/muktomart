import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/messages_model.dart';
import 'package:mukto_mart/repo/message_repo.dart';

class MessagesProvider extends ChangeNotifier{
  MessagesRepo _messagesRepo=MessagesRepo();
  Messages _messages;

  get messagesRepo => _messagesRepo;
  Messages get messages => _messages;

  Future<void> fetch(String token)async {
    var result = await _messagesRepo.getAllMessages(token);
    _messages=result;
    notifyListeners();
  }
}