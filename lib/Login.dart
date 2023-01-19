
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DataHendler.dart';
import 'Register.dart';
import 'ProfileView.dart';

TextEditingController Email = new TextEditingController();
TextEditingController Password = new TextEditingController();

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _myValidKey = GlobalKey<FormState>();
  SaveDataLocally savedata = new SaveDataLocally();
  bool isLogin = false;
  bool _isHidden = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }
  checkUser() async {
    bool isUser = await savedata.checkUserAvabilty();
    print("Is User : ");
    print(isUser);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: Form(
                    key: _myValidKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              'https://img.freepik.com/premium-vector/brunette-man-avatar-portrait-young-guy-vector-illustration-face_217290-1035.jpg?w=2000'),
                        ),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: TextFormField(
                            controller: Email,
                            validator: (Email) {
                              if (Email!.isEmpty) {
                                return "Enter the Email";
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email",
                                hintText: "Enter your email"),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20,20),
                          child: TextFormField(
                            obscureText: _isHidden,
                            controller: Password,
                            validator: (Password) {
                              if (Password!.isEmpty) {
                                return "Enter the Password";
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Password",
                                hintText: "Password" , suffix: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(_isHidden ? Icons.visibility:Icons.visibility_off ),
                            )),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                bool result = _myValidKey.currentState!.validate();

                                if (result) {
                                  if (await savedata.getEmail() == Email.text) {
                                    isLogin = true;
                                    setState(() {});
                                  } else {
                                    isLogin = false;
                                    setState(() {});
                                  }
                                  if (await savedata.getPassword() == Password.text) {
                                    isLogin = true;
                                    setState(() {});
                                  } else {
                                    isLogin = false;
                                    setState(() {});
                                  }
                                  if (isLogin == true) {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileView()));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Please enter valid details");
                                  }
                                }
                              },
                              child: Text('Login'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Register()));
                              },
                              child: Text('Registration'),
                            )
                          ],
                        )
                      ],
                    )
                )
            )
        )
    );
  }
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}