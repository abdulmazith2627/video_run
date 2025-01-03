

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'addsub.dart';

class getSubs extends GetxController{

  final supabase = Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  var subUser=[].obs;


  getSubscribeData()async{
    final res=await supabase.from('subscribe').select().eq('users_uid',currentUser!.id);
    subUser.value=res;
  }




  @override
  void onInit() {
    getSubscribeData();
    super.onInit();
  }
}