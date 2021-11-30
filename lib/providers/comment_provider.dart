import 'package:flutter/cupertino.dart';
import 'package:mukto_mart/models/comment_model.dart';
import 'package:mukto_mart/repo/comment_repo.dart';

class CommentProvider extends ChangeNotifier{
  CommentsRepo _commentsRepo=CommentsRepo();
  Comments _comments;

  get commentsRepo => _commentsRepo;
  Comments get comments => _comments;

  Future<void> fetch(int productId)async {
    var result = await _commentsRepo.getAllComments(productId);
    _comments=result;

    notifyListeners();
  }
}