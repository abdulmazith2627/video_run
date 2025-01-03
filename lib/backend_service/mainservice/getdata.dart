

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'addsub.dart';

class GetUserData extends GetxController {
  final supabase = Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  final sub=Get.put(Subs());

  var postData = [].obs;
  var videoData = [].obs;
  var reelsData = [].obs;
  var allData = [].obs;
  var userData=[].obs;

  void fetchAllData() async {
    try {

      final postRes = await supabase.from('post').select('*');
      final videoRes = await supabase.from('video').select('*');
      final reelRes = await supabase.from('reel').select('*');


      postData.value = postRes ?? [];
      videoData.value = videoRes ?? [];
      reelsData.value = reelRes ?? [];
      postData;
      videoData;
      reelsData;

      allData.assignAll([
        ...postData,
        ...videoData,
      ]);
      allData.shuffle(Random());
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void userdatas()async{
    try {

      final res = await supabase.from('users').select('*').eq('uid',currentUser!.id);
      userData.value = res ?? [];
      print("email : ${userData[0]['profile_url']}");
    } catch (e) {
      print('Error fetching data: $e');
    }

  }

  @override
  void onInit() {
    fetchAllData();
    userdatas();
   Timer.periodic(Duration(minutes:2),(_)=>fetchAllData());
    super.onInit();
  }
}
