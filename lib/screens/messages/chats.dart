import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mukto_mart/repo/message_repo.dart';
import 'package:mukto_mart/screens/messages/conversation_screen.dart';
import 'package:mukto_mart/screens/messages/send_message.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/providers/messages_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  bool _isLoading=false;
  String token;
  @override
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
    MessagesRepo messageRepo=MessagesRepo();
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: ()async{
              setState(() {
                _isLoading=true;
              });
              await messagesProvider.fetch(token).then((value){
                setState(() {
                  _isLoading=false;
                });
              });
            },
            child: Container(
              color: Colors.white,
              height: size.height*.9,
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: messagesProvider.messages==null?0:messagesProvider.messages.convs==null?0:messagesProvider.messages.convs.length,
                itemBuilder: (context, index) {
                  final message = messagesProvider.messages.convs[index];
                  DateTime t = messagesProvider.messages.convs[index].createdAt.date;
                  return ListTile(
                    onTap: () async{
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                          ConversationScreen(index: index,)));
                    },
                    leading: Icon(Icons.account_circle,
                        size: size.height * .075,
                        color: Colors.grey[500]),
                    title: Text('${message.recievedUser}',style: TextStyle(fontSize: size.width * .037, fontWeight: FontWeight.bold, color: Colors.black)),
                    subtitle:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message.message,maxLines: 1,style:TextStyle(fontSize: size.width * .032, fontWeight: FontWeight.normal, color: Colors.black)),
                        Text(
                          DateFormat.yMMMd().add_jm().format(t),
                          style: TextStyle(color: Colors.grey, fontSize: size.width * .027),
                        ),
                      ],
                    ),
                    trailing: InkWell(
                      onTap: (){
                        setState(() {
                          _isLoading=true;
                        });
                        messageRepo.deleteMessage(token, message.id).then((value){
                          setState(() {
                            _isLoading=false;
                          });
                          _showToast('Message deleted', kPrimaryColor);
                        });
                      },
                        child: Icon(Icons.delete))
                  );
                },
              ),
            ),
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.message),
        onPressed: () {
          token==''?null:token==null?_showToast('Please log in first', Colors.redAccent):Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
              SendMessage()));
        },

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
