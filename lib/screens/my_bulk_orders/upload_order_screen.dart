import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mukto_mart/components/default_button.dart';
import 'package:mukto_mart/providers/bulk_order_provider.dart';
import 'package:mukto_mart/repo/bulk_order_repo.dart';
import 'package:mukto_mart/variables/constants.dart';
import 'package:mukto_mart/variables/size_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_bulk_order_screen.dart';

class UploadOrder extends StatefulWidget {
  @override
  _UploadOrderState createState() => _UploadOrderState();
}

class _UploadOrderState extends State<UploadOrder> {
  FilePickerResult uploadFile;
  File file;
  String token;
  String path='';
  bool _isLoading = false;

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

  Future<void> chooseFile() async {
    uploadFile = await FilePicker.platform.pickFiles();

    if (uploadFile != null) {
      file = File(uploadFile.files.single.path);
    } else {
      // User canceled the picker
    }
    print(file);

    setState(() {
      path=file.path;
    }); //update the UI so that file name is shown
  }
  Future<void> chooseImage() async {
    var choosedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      file = File(choosedImage.path);
    });
    setState(() {
      path=file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final BulkOrderProvider bulkOrderProvider = Provider.of<BulkOrderProvider>(context,listen: false);
    BulkOrderRepo bulkOrderRepo = BulkOrderRepo();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), onPressed: () {
          Navigator.pop(context);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) {
          //   return HomeScreen();  }));
        },),
        title: Text("Upload Order File",style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height:20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: size.width*.65,
                      child: Text(path,style: TextStyle(fontSize: size.width*.035),),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[600],width: 3)
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext ctxt){
                              return AlertDialog(
                                contentPadding: EdgeInsets.all(20),
                                title: Text("Select File"),
                                content: Container(
                                  height: MediaQuery.of(context).size.height * .18,
                                  child: Column(
                                    children: <Widget>[
                                      Divider(color: Colors.black,),
                                      InkWell(
                                        child: Text("Take Photo",style: TextStyle(fontWeight: FontWeight.bold)),
                                        onTap: ()=> chooseImage(),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.width * .020,
                                      ),
                                      Divider(color: Colors.black,),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.width * .020,
                                      ),
                                      InkWell(
                                        child: Text("Choose File",style: TextStyle(fontWeight: FontWeight.bold),),
                                        onTap: ()=> chooseFile(),
                                      ),
                                      Divider(color: Colors.black,),

                                    ],
                                  ),

                                ),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text(
                                        "Cancel",style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor),
                                    ),
                                    onPressed: ()=>Navigator.pop(ctxt),
                                  )
                                ],
                              );
                            }
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.grey[600],width: 3)
                        ),
                        height: 60,
                        width: size.width*.28,
                        child: Center(child: Text('Select File',style: TextStyle(color: Colors.white),)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: SizedBox(
                      width: getProportionateScreenWidth(130),
                      child: DefaultButton(
                        text: "Upload",
                        press: () {
                         if(file!=null){
                           if (token != null) {
                             setState(() {
                               _isLoading = true;
                             });
                             bulkOrderRepo.uploadFile(file, token).then((value) async{
                               await bulkOrderProvider.fetch(token);
                               _showToast('Your order is placed.Please wait for your order confirmation', kPrimaryColor);
                               Navigator.push(context, MaterialPageRoute(builder: (_) {
                                 return MyBulkOrders();}));
                             });
                           } else {
                             _showToast('Please log in first', Colors.redAccent);
                           }
                         }else {
                           _showToast('Please Choose a file', Colors.redAccent);
                         }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _isLoading?Center(child: CircularProgressIndicator()):Container()
        ],
      ),
    );
  }

  void _showToast(String message, Color color) {
    setState(() {
      _isLoading = false;
    });
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
