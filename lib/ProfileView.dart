import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'DataHendler.dart';


class ProfileView extends StatefulWidget {

  @override
  State<ProfileView> createState() => _ProfileViewState();
}
class _ProfileViewState extends State<ProfileView> {
  SaveDataLocally savedata = new SaveDataLocally();
  String? Name;
  String? Username;
  String? Email;
  String? Date;
  String? Address;
  String? imagepath;
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }
  void getData()async{
     Name = await savedata.getName();
     Username = await savedata.getUserName();
     Email = await savedata.getEmail();
     Date = await savedata.getDate();
     Address = await savedata.getAddress();
     imagepath = await savedata.getImage();
     setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundImage: Image.file(File(imagepath!)).image
                ),
                ListTile(
                  title: Text('Name',
                    style: TextStyle(color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),),
                  subtitle: Text(
                    Name??"",
                    style: TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  title: Text('Username',
                    style: TextStyle(color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),),
                  subtitle: Text(
                    Username??"",
                    style: TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  title: Text('Email',
                    style: TextStyle(color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),),
                  subtitle: Text(
                    Email??"",
                    style: TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  title: Text('DOB',
                    style: TextStyle(color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),),
                  subtitle: Text(
                    Date??"",
                    style: TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                ListTile(
                  title: Text('Address',
                    style: TextStyle(color: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),),
                  subtitle: Text(
                    Address??"",
                    style: TextStyle(color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}