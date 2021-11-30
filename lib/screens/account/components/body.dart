import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mukto_mart/providers/profile_provider.dart';
import 'package:mukto_mart/screens/profile/components/profile_pic.dart';
import 'package:mukto_mart/screens/profile/components/update_profile.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context,listen: false);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 10),
          Text('${profileProvider.userProfile.user.name}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Divider(height:10,color: Colors.blueGrey,),
          Padding(
            padding: const EdgeInsets.only(left:14.0,right: 14.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Personal Information'),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        UpdateProfile()), (Route<dynamic> route) => false);
                  },
                    child: Text('Edit',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.person),
              SizedBox(width: 20),
              Text('Name',style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 50),
              Text('${profileProvider.userProfile.user.name??'Not set yet'}',style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.email),
              SizedBox(width: 20),
              Text('Email',style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 50),
              Text('${profileProvider.userProfile.user.email??'Not set yet'}',style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.phone),
              SizedBox(width: 20),
              Text('Contact Number',style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 50),
              Text('${profileProvider.userProfile.user.phone??'Not set yet'}',style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 10),
              Icon(Icons.location_on),
              SizedBox(width: 20),
              Text('Address',style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 50),
              Text('${profileProvider.userProfile.user.address??'Not set yet'}',style: TextStyle(fontWeight: FontWeight.normal)),
            ],
          ),
        ],
      ),
    );
  }
}
