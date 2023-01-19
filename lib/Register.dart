import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'DataHendler.dart';
import 'Login.dart';


TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController username = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController c_password = TextEditingController();
TextEditingController date = TextEditingController();
TextEditingController address = TextEditingController();


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  State<Register> createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
  SaveDataLocally savedata = new SaveDataLocally();
  bool _isHidden = true;
  bool _isHidden1 = true;
  File? profileImage;

  RegExp pass_valid = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  RegExp email_valid = RegExp("^[a-zA-Z0-9+_.-]+@gmail.com");

  void  _datePicker() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2024));

    if (pickedDate != null) {
      print(
          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      print(formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        date.text = formattedDate; //set output date to TextField value.
      });
    } else {}
  }

  Future pickProfileFromGallary() async {
    final profileImagePicker = await ImagePicker().pickImage(source: ImageSource.gallery);
    File? profile = File(profileImagePicker!.path);
    if(profileImagePicker == null ) return;
    final path = profile!.path;
    savedata.saveImage(path);
    print('image path');
    print(path);
    setState(() {
      profileImage = profile;
    });
  }
  Future pickProfileFromCamera() async {
    final profileImagePicker = await ImagePicker().pickImage(source: ImageSource.camera);
    File? profile = File(profileImagePicker!.path);
    if(profileImagePicker == null ) return;
    final path = profile!.path;
   savedata.saveImage(path);
    print('image path');
    print(path);
    setState(() {
      profileImage = profile;
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  void _togglePasswordView1() {
    setState(() {
      _isHidden1 = !_isHidden1;
    });
  }

  bool validateEmail(String Email) {
    String _email = Email.trim();
    if (email_valid.hasMatch(_email)) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePassword(String pass) {
    String _password = pass.trim();

    if (pass_valid.hasMatch(_password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {


    var _myFormKey = GlobalKey<FormState>();

    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(40, 100, 40, 0),
          child: Form(
            key: _myFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipOval( child:  (profileImage != null)
                    ? Image.file(profileImage! ,height: 110,width: 110,fit: BoxFit.fill,)
                    : FlutterLogo(size: 55,),
                ),
                // Spacer(),
                ElevatedButton.icon(
                  onPressed: (){
                    showModalBottomSheet<void>(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30)
                        )
                      ),
                      builder: (BuildContext context) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: pickProfileFromGallary,
                                        icon: Icon( // <-- Icon
                                          Icons.photo,
                                          size: 24.0,
                                        ),
                                        label: Text('Upload From Gallary'), // <-- Text
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: pickProfileFromCamera,
                                        icon: Icon( // <-- Icon
                                          Icons.camera,
                                          size: 24.0,
                                        ),
                                        label: Text('Upload From Camera'), // <-- Text
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon( // <-- Icon
                                          Icons.cancel,
                                          size: 24.0,
                                        ),
                                        label: Text('Cancel'), // <-- Text
                                      ),
                                    ],
                                ),
                              ),
                            );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_a_photo
                  ),
                  label: Text('Upload Profile'),
                ),
                TextFormField(
                  controller: name,
                  validator: (name) {
                    if (name!.isEmpty) {
                      return "Enter name";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Name', hintText: 'Enter your full name'),
                ),
                TextFormField(
                  controller: username,
                  validator: (username) {
                    if (username!.isEmpty){
                      return "Enter username";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Username', hintText: 'Enter your username'),
                ),
                TextFormField(
                  controller:email,
                  validator: (email) {
                    if (email!.isEmpty) {
                      return 'Enter Email';
                    } else {
                      if (validateEmail(email)) {
                        return null;
                      } else {
                        return "invalid Email";
                      }
                    }
                  },
                  decoration:
                  InputDecoration(labelText: 'Email', hintText: 'Email'),
                  onChanged: (val) {},
                ),
                TextFormField(
                    obscureText: _isHidden,
                    controller: password,
                    validator: (passcode) {
                      if (passcode!.isEmpty) {
                        return 'Enter password';
                      } else {
                        if (validatePassword(passcode)) {
                          return null;
                        } else {
                          return "Password contain atleast 8 charachter \n"
                              "1 capital letter \n"
                              "1 small letter \n"
                              "1 number \n"
                              "1 special character";
                        }
                      }
                    },
                    decoration: InputDecoration(labelText: 'Password', suffix: InkWell(
                      onTap: _togglePasswordView,
                      child: Icon(
                          _isHidden? Icons.visibility:Icons.visibility_off
                      ),
                    ))
                ),
                TextFormField(
                  obscureText: _isHidden1,
                  controller: c_password,
                  decoration: InputDecoration(labelText: 'Confirm Password' , suffix: InkWell(
                    onTap: _togglePasswordView1,
                    child: Icon(
                        _isHidden1?Icons.visibility:Icons.visibility_off
                    ),
                  )),
                  validator: (passcode) {
                    if (password.text == passcode) {
                      return null;
                    } else {
                      return "Invalid Confirm password";
                    }
                  },
                ),
                TextFormField(
                  controller: date,
                  decoration: InputDecoration( labelText: 'Date Of Birth',suffixIcon: IconButton(
                    onPressed: _datePicker,
                    icon: Icon(Icons.calendar_month),
                  )
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextFormField(
                    controller: address,
                    minLines: 4,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    bool? valid = _myFormKey.currentState?.validate();
                    if(valid == true){

                      savedata.setName(name.text);
                      savedata.setUsername(username.text);
                      savedata.setEmail(email.text);
                      savedata.setPassword(password.text);
                      savedata.setCPassword(c_password.text);
                      savedata.setDate(date.text);
                      savedata.setAddress(address.text);
                      Fluttertoast.showToast(msg: 'Registered successfully');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    }else{
                      _myFormKey.currentState?.validate();
                    };
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }
}