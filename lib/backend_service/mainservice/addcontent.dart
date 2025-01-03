import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_app/backend_service/mainservice/getdata.dart';

import '../../pages/tabs/homepage.dart';
import '../../widget/snackbar.dart';

class AddContent extends GetxController{
  final supabase=Supabase.instance.client;
  final currentUsers=Supabase.instance.client.auth.currentUser;
  final fecthdata=Get.put(GetUserData());
  var userData ={};

  void userdatas()async{
    try {

      final res = await supabase.from('users').select('*').eq('uid',currentUsers!.id).single();
      userData=res;
      print("Url : ${userData['profile_url']}");
    } catch (e) {
      print('Error fetching data: $e');
    }

  }
  // add post function
 
Future addPost(
  {
    required Uint8List post_image,
    required String title,
    required String des,
}
    )async{
  try{
    final filename='${DateTime.now().microsecondsSinceEpoch}.jpg';
    var path='post/$filename';
     await supabase.storage.from('images').uploadBinary(path,post_image);
     final imageUrl=supabase.storage.from('images').getPublicUrl(path);
    final res=await supabase.from('post').insert(
      {
        'uid':currentUsers!.id,
        'post_url':imageUrl,
        'title':title,
        'des':des,
        'username':userData['username'],
        'profile':userData['profile_url'],
        'method':'post'
      }
    );
    fecthdata.fetchAllData();
    Get.back();
  }catch(e){
    showSnackBar('Error','post : $e');
    print(e);
  }
}


Future addVideo(
  {
   required Uint8List? image,
    required  File? video,
    required String title,
    required String des,
}
    )async{
     try{
       final thum_filename="${DateTime.now().microsecondsSinceEpoch}_thumb.jpg";
       final video_filename="${DateTime.now().microsecondsSinceEpoch}";
       var thu_path='thum/$thum_filename';
       var video_path='video/$video_filename';
       await supabase.storage.from('images').uploadBinary(thu_path,image!);
       await supabase.storage.from('images').upload(video_path,video!);
       final thum_url=supabase.storage.from('images').getPublicUrl(thu_path);
       final vedio_url=supabase.storage.from('images').getPublicUrl(video_path);
       final res=await supabase.from('video').insert({
         'uid':currentUsers!.id,
         'thumbnail':thum_url,
         'video':vedio_url,
         'title':title,
         'des':des,
         'username':userData['username'],
         'profile':userData['profile_url'],
         'method':'video'
       });
       fecthdata.fetchAllData();
     showSnackBar("Successfully", "post Your Video");
       Get.back();
     }catch(e){
       showSnackBar('Error','post : $e');
     print(e);}
}


  Future addReels(
      {
        required  File? video,
        required String title,
        required String des,
      }
      )async{
    try{
      final reels_filename="${DateTime.now().microsecondsSinceEpoch}";
      var video_path='reels/$reels_filename';
      await supabase.storage.from('images').upload(video_path,video!);
      final vedio_url=supabase.storage.from('images').getPublicUrl(video_path);
      final res=await supabase.from('reel').insert({
        'uid':currentUsers!.id,
        'reels':vedio_url,
        'title':title,
        'des':des,
        'username':userData['username'],
        'profile':userData['profile_url'],
        'method':'reels'
      });
      fecthdata.fetchAllData();
      showSnackBar("Successfully", "post Your reels");
      Get.back();
    }catch(e){
      showSnackBar('Error','post : $e');
      print(e);}
  }



  @override
  void onInit() {
    userdatas();
    super.onInit();
  }
}