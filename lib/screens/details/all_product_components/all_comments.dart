import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/providers/comment_provider.dart';
import 'package:mukto_mart/repo/comment_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllComments extends StatefulWidget {
  final int productId;

  const AllComments({Key key, this.productId}) : super(key: key);
  @override
  _AllCommentsState createState() => _AllCommentsState();
}

class _AllCommentsState extends State<AllComments> {
  String token;
  String userId;
  bool _isLoading = false;
  final _addKey = GlobalKey<FormState>();
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  String commentText;
  final replyTextController = TextEditingController();
  final editCommentController = TextEditingController();
  final editReplyController = TextEditingController();
  final commentTextController = TextEditingController();
  CommentsRepo commentsRepo = CommentsRepo();
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
      userId = preferences.getString('userId');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final CommentProvider commentProvider = Provider.of<CommentProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("All Comments"),
      ),
      body: _isLoading?Center(child: CircularProgressIndicator()):Container(
        height: size.height,
        child: Padding(
          padding: const EdgeInsets.only(top:12.0),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(10),
                  ),
                  child: commentProvider.comments!= null?
                  commentProvider.comments.comdata!= null
                      ? commentProvider.comments.comdata.isNotEmpty
                      ? ListView.builder(
                      physics: new ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: commentProvider.comments.comdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime time = DateTime.parse(commentProvider
                            .comments.comdata[index].createdAt);
                        return Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: commentProvider.comments
                                      .comdata[index].userphoto ==
                                      'https://muktomart.com/assets/images/users'
                                      ? Icon(Icons.person_outline)
                                      : Image.network(commentProvider
                                      .comments.comdata[index].userphoto),
                                  radius: size.width * .05,
                                ),
                                // Text(f.format(time),style: TextStyle(fontSize: size.width*.028)),
                                SizedBox(
                                  width: 18,
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      commentProvider
                                          .comments.comdata[index].username,
                                      style: TextStyle(
                                          fontSize: size.width * .035,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        commentProvider
                                            .comments.comdata[index].text,
                                        style: TextStyle(
                                            fontSize: size.width * .035)),
                                    SizedBox(height: 2),
                                    Text(f.format(time),
                                        style: TextStyle(
                                            fontSize: size.width * .028)),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Icon(Icons.reply,
                                            size: size.width * .06),
                                        InkWell(
                                          child: Text('Reply',
                                              style: TextStyle(
                                                  fontSize:
                                                  size.width * .033)),
                                          onTap: () {
                                            _showReplyDialog(commentProvider.comments.comdata[index].id,commentProvider);
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        '${commentProvider.comments.comdata[index].userId}' ==
                                            '$userId'
                                            ? Icon(Icons.edit,
                                            size: size.width * .06)
                                            : Container(),
                                        '${commentProvider.comments.comdata[index].userId}' ==
                                            '$userId'
                                            ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              editCommentController.text=commentProvider.comments.comdata[index].text;
                                            });
                                            _showEditDialog(commentProvider.comments.comdata[index].id,commentProvider);
                                          },
                                          child: Text('Edit',
                                              style: TextStyle(
                                                  fontSize:
                                                  size.width * .033)),
                                        )
                                            : Container(),
                                        SizedBox(width: 10),
                                        '${commentProvider.comments.comdata[index].userId}' ==
                                            '$userId'
                                            ? Icon(Icons.delete,
                                            size: size.width * .05)
                                            : Container(),
                                        '${commentProvider.comments.comdata[index].userId}' ==
                                            '$userId'
                                            ? InkWell(
                                          onTap: (){
                                            setState(() {
                                              _isLoading=true;
                                            });
                                            commentsRepo.deleteComment(token,
                                                commentProvider.comments.comdata[index].id).then((value)async{
                                              await commentProvider.fetch(widget.productId).then((value){
                                                setState(() {
                                                  _isLoading=false;
                                                });
                                                _showToast('Comment deleted', kPrimaryColor);
                                              });
                                            });},
                                          child: Text('Delete',
                                              style: TextStyle(
                                                  fontSize:
                                                  size.width * .033)),
                                        )
                                            : Container(),
                                      ],
                                    ),

                                    SizedBox(height: 15),
                                  ],
                                ),
                              ],
                            ),
                            commentProvider.comments.comdata[index].replies
                                .isNotEmpty
                                ? Row(
                              children: [
                                SizedBox(width: size.width * .2),
                                Expanded(
                                  child: ListView.builder(
                                      physics:
                                      new ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: commentProvider
                                          .comments
                                          .comdata[index]
                                          .replies
                                          .length,
                                      itemBuilder:
                                          (BuildContext context,
                                          int dx) {
                                        DateTime tm = DateTime.parse(commentProvider
                                            .comments.comdata[index].replies[dx].createdAt);
                                        var dta = commentProvider
                                            .comments
                                            .comdata[index]
                                            .replies[dx];
                                        return Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              Colors.grey,

                                              child: dta.userphoto == 'https://muktomart.com/assets/images/users'
                                                  ?Icon(Icons.person_outline)
                                                  : Image.network(dta.userphoto),
                                              radius: size.width * .05,
                                            ),
                                            // Text(f.format(time),style: TextStyle(fontSize: size.width*.028)),
                                            SizedBox(
                                              width: 18,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  '${dta.username}',
                                                  style: TextStyle(
                                                      fontSize:
                                                      size.width *
                                                          .035,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                                Text(dta.text,
                                                    style: TextStyle(
                                                        fontSize:
                                                        size.width *
                                                            .035)),
                                                SizedBox(height: 2),
                                                Text(
                                                    f.format(
                                                        tm),
                                                    style: TextStyle(
                                                        fontSize:
                                                        size.width *
                                                            .028)),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    '${dta.userId}' ==
                                                        '$userId'
                                                        ? Icon(Icons.edit,
                                                        size: size.width * .06)
                                                        : Container(),
                                                    '${dta.userId}' ==
                                                        '$userId'
                                                        ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          editReplyController.text=dta.text;
                                                        });
                                                        _showReplyEditDialog(dta.id,commentProvider);
                                                      },
                                                      child: Text('Edit',
                                                          style: TextStyle(
                                                              fontSize:
                                                              size.width * .033)),
                                                    )
                                                        : Container(),
                                                    SizedBox(width: 10),
                                                    '${dta.userId}' ==
                                                        '$userId'
                                                        ? Icon(Icons.delete,
                                                        size: size.width * .05)
                                                        : Container(),
                                                    '${dta.userId}' ==
                                                        '$userId'
                                                        ? InkWell(
                                                      onTap: (){
                                                        setState(() {
                                                          _isLoading=true;
                                                        });
                                                        commentsRepo.deleteReply(token,
                                                            dta.id).then((value)async{
                                                          await commentProvider.fetch(widget.productId).then((value){
                                                            setState(() {
                                                              _isLoading=false;
                                                            });
                                                            _showToast('Reply deleted', kPrimaryColor);
                                                          });
                                                        });},
                                                      child: Text('Delete',
                                                          style: TextStyle(
                                                              fontSize:
                                                              size.width * .033)),
                                                    )
                                                        : Container(),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ],
                            )
                                : Container(),
                          ],
                        );
                      })
                      : Text('No comments')
                      : Text('No comments')
                      : Text('No comments')),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 15,right: 15),
                height: size.width * .17,
                width: double.infinity,
                color: Colors.white70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        maxLines: null,minLines: null,
                        expands: true,
                        controller: commentTextController,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            hintText: "Write your comment...",
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none),
                        onChanged: (value) {
                          commentText = value;
                        },
                      ),
                    ),
                    SizedBox(width: size.width * .04),
                    InkWell(
                      onTap: (){
                        if(token==null){
                          _showToast('Please log in first', Colors.redAccent);
                        }else{
                          setState(() {
                            _isLoading=true;
                          });
                          commentsRepo.addComment(widget.productId, token, commentText).then((value)async{
                            await commentProvider.fetch(widget.productId).then((value){
                              commentTextController.clear();
                              setState(() {
                                _isLoading=false;
                              });
                              _showToast('Comment sent', kPrimaryColor);
                            });
                          });
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(getProportionateScreenWidth(5)),
                        height: getProportionateScreenWidth(45),
                        width: getProportionateScreenWidth(65),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Text(
                              'Post',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _showReplyDialog(int id,CommentProvider commentProvider) {
    String reply;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Write your reply",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Write your reply'),
                      onSaved: (val) {
                        reply = val;
                      },
                      validator: (val) =>
                      val.isEmpty ? 'please write reply' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _isLoading=true;
                            });
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                              commentsRepo.replyComment(id, token, reply).then((value)async{
                                await commentProvider.fetch(widget.productId).then((value){
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  _showToast('reply sent', kPrimaryColor);
                                });
                              });
                            }

                          },
                          child: Text(
                            "post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showEditDialog(int id,CommentProvider commentProvider) {
    String editText;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Edit your comment",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: editCommentController,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Edit your comment'),
                      onSaved: (val) {
                        editText = val;
                        //editCommentController.text=editText;
                      },
                      onChanged:(val){
                        setState(() {
                          editText=editCommentController.text;
                        });
                      },
                      validator: (val) =>
                      val.isEmpty ? 'please write comment' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _isLoading=true;
                            });
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                              commentsRepo.editComment(id, token, editText).then((value)async{
                                await commentProvider.fetch(widget.productId).then((value){
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  _showToast('comment updated', kPrimaryColor);
                                });
                              });
                            }

                          },
                          child: Text(
                            "post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showReplyEditDialog(int id,CommentProvider commentProvider) {
    String replyEditText;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text(
              "Edit your reply",
              textAlign: TextAlign.center,
            ),
            content: Container(
              child: Form(
                key: _addKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: editReplyController,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(hintText: 'Edit your reply'),
                      onSaved: (val) {
                        replyEditText = val;
                        //editCommentController.text=editText;
                      },
                      onChanged:(val){
                        setState(() {
                          replyEditText=editReplyController.text;
                        });
                      },
                      validator: (val) =>
                      val.isEmpty ? 'please write reply' : null,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        RaisedButton(
                          color: kPrimaryColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _isLoading=true;
                            });
                            if (_addKey.currentState.validate()) {
                              _addKey.currentState.save();
                              commentsRepo.editReply(id, token, replyEditText).then((value)async{
                                await commentProvider.fetch(widget.productId).then((value){
                                  setState(() {
                                    _isLoading=false;
                                  });
                                  _showToast('Reply updated', kPrimaryColor);
                                });
                              });

                            }

                          },
                          child: Text(
                            "post",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
