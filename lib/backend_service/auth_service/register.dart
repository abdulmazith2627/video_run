import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/login.dart';
import '../../pages/connectionpage.dart';
import '../../widget/snackbar.dart';


class RegisterUser extends GetxController{
final supabase=Supabase.instance.client;
final localStorage=Hive.box('userdata');
var userdata={}.obs;


// signup function

  Future signUpUser(
  {
    required Uint8List profile,
    required String email,
    required String password,
    required String username
}
)async{
    try{

      final res=await supabase.auth.signUp(
          email:email,
          password: password
      );
      if(res.user!=null) {
        final filename = '${DateTime.now().microsecondsSinceEpoch}.jpg';
        var path = 'profile/$filename';
        await supabase.storage.from('images').uploadBinary(path, profile);
        final imageUrl = supabase.storage.from('images').getPublicUrl(path);
       await supabase.from('users').insert({
          'profile_url':imageUrl.isEmpty?null:imageUrl,
          'email':email,
          'username':username,
          'uid':res.user!.id,
        });
           showSnackBar('SuccessFully',"signup Successfully");

      }
    }catch(e){
      String msg='Something gose Worng';
      if(e is AuthException){
        msg=e.message;
        showSnackBar('Error','Signup : $msg');
        print('Error on Signup : $msg');
      }
    }


    }


    // login User

 Future loginUser(
  {
    required String email,
    required String password
}
     )async{
    try{
      final res=await supabase.auth.signInWithPassword(
          email:email,
          password: password
      );
   if(res.user!=null){
    localStorage.put('data', res.user!.email);
    haveData();
     Get.offAll(()=>ConnectionPage());
   }
    }catch(e){
      String msg='Something gose Worng';
      if(e is AuthException){
        msg=e.message;
        showSnackBar('Error','Login : $msg');
        print('Error on login : $msg');
      }
    }
 }

 logout()async{
    await supabase.auth.signOut();
    localStorage.delete('data');
    haveData();
    Get.offAll(()=>LoginPage());
 }

Future haveData()async{
    var data=localStorage.get('data');
    print(data);
    return data;
}

@override
  void onInit() {
  logout();
  haveData();
    super.onInit();
  }

  }



