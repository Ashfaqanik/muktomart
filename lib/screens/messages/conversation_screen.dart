import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/models/messages_model.dart';
import 'package:mukto_mart/providers/messages_provider.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/repo/message_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConversationScreen extends StatefulWidget {
  final int index;

  ConversationScreen({this.index});

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  final messageTextController = TextEditingController();
  String messageText;
  String token;
  bool _isLoading=false;
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }
  void _checkPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('api_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final MessagesProvider messagesProvider = Provider.of<MessagesProvider>(context);
    MessagesRepo messagesRepo=MessagesRepo();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () async {
              Navigator.pop(context);
            }),
        toolbarHeight: size.height * .08,
        title: Text(
          '${messagesProvider.messages.convs[widget.index].recievedUser}',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Stack(
        children: [
          Container(
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: messagesProvider.messages.convs[widget.index].messages.length,
                    padding: EdgeInsets.only(top: 10, bottom: 90),
                    reverse: false,
                    itemBuilder: (BuildContext context,int index){
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child:
                            // commentProvider.comments
                            //     .comdata[index].userphoto ==
                            //     'https://muktomart.com/assets/images/users'
                            //     ?
                            Icon(Icons.person_outline),
                            // : Image.network(commentProvider
                            // .comments.comdata[index].userphoto),
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
                                '${messagesProvider.messages.convs[widget.index].messages[index].sentUser}',
                                style: TextStyle(
                                    fontSize: size.width * .035,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  messagesProvider.messages.convs[widget.index].messages[index].message,
                                  style: TextStyle(
                                      fontSize: size.width * .035)),
                              SizedBox(height: 2),
                              Text(f.format(messagesProvider.messages.convs[widget.index].messages[index].createdAt.date),
                                  style: TextStyle(
                                      fontSize: size.width * .028)),

                              SizedBox(height: 15),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: size.width * .20,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: size.width * .04,
                    ),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: true,
                        controller: messageTextController,
                        style: TextStyle(color: Colors.grey[800]),
                        //textCapitalization: TextCapitalization.sentences,
                        autocorrect: true,
                        enableSuggestions: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.blueGrey),
                          hintText: 'Write your message..',
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            borderSide: const BorderSide(
                              color: kPrimaryColor,
                              width: 0.5,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          messageText = value;
                        },
                      ),
                    ),
                    SizedBox(
                      width: size.width * .04,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if(token==null||token==''){
                          _showToast('Please log in first', Colors.redAccent);
                        }else{
                          messageTextController.clear();
                          setState(() {
                            _isLoading = true;
                          });
                          messageText!=null?messagesRepo.addConverdation(token, messagesProvider.messages.convs[widget.index].id, messageText, messagesProvider.messages.convs[widget.index].sentUser).then((value){
                            messagesProvider.fetch(token).then((value){
                              setState(() {
                                _isLoading = false;
                              });
                              _showToast('Message Sent', kPrimaryColor);
                            });
                          }):null;
                        }
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: size.width * .06,
                      ),
                      backgroundColor: kPrimaryColor,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
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
}
