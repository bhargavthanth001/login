
import 'package:shared_preferences/shared_preferences.dart';



class SaveDataLocally {

  SharedPreferences? preference;

  Future<bool> checkUserAvabilty() async {
    preference = await SharedPreferences.getInstance();
    String? eMAIL = preference?.getString("email");
    if(eMAIL == null){
      return false;
    }else{
      return true;
    }
  }
  //Setters
  setName(String? name) async {
    preference = await SharedPreferences.getInstance();
    return  preference?.setString('name',name!);
  }
  setUsername(String? username) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('username',username!);
  }
  setEmail(String? email) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('email',email!);
  }
  setPassword(String? password) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('password',password!);
  }
  setCPassword(String? c_password) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('cpassword',c_password!);
  }
  setDate(String? date) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('date',date!);
  }
  setAddress(String? address) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('address',address!);
  }

  //Getters
  Future<String> getName() async {
    preference = await SharedPreferences.getInstance();
    return preference?.getString('name') ?? "";
  }
  Future<String> getUserName() async {
    preference = await SharedPreferences.getInstance();
    return preference?.getString('username') ?? "";
  }

  Future<String> getDate() async {
    preference = await SharedPreferences.getInstance();
    return  preference?.getString('date') ?? "";
  }
  Future<String> getAddress() async {
    preference = await SharedPreferences.getInstance();
    return preference?.getString('address') ?? "";
  }

  Future<String> getEmail() async {
     preference = await SharedPreferences.getInstance();
     return preference?.getString('email') ?? "";
   }

   Future<String> getPassword() async {
     preference = await SharedPreferences.getInstance();
     return  preference?.getString('password') ?? "";
   }

  saveImage(image) async {
    preference = await SharedPreferences.getInstance();
    return preference?.setString('profile',image!);
  }
   Future<String>? getImage() async {
     preference = await SharedPreferences.getInstance();
     return preference!.getString('profile') ?? "";
  }
}
