


import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widget/snackbar.dart';

class AddComment extends GetxController{

  final supabase=Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  var userDataComment={}.obs;
  var commentDatas=[].obs;
  Random random=Random();


  Future addComments(
  {
    required String uid,
    required String username,
    required String profile,
    required String comment,
    required String user_uid,
    required int id
}
      )async{

    try{
      userdatas();
      final res=await supabase.from('comment').insert({
        'uid':uid,
        'username':username,
        'profile':profile,
        'comments':comment,
        'users_uid':user_uid,
        'video_id':id
      });

      getCommentData(id:id);
      print('comment done');

      random;

    }catch(e){
      showSnackBar('Error','addComment : $e');
      print(e);
    }
  }

  Future<void> deleteCom({
    required int id,
  }) async {
    try {

      await supabase.from('comment').delete().eq('id', id);


      commentDatas.removeWhere((comment) => comment['id'] == id);

      userdatas();
    } catch (e) {
      showSnackBar('Error', 'Delete comment failed: $e');
      print('Error deleting comment: $e');
    }
  }

  void userdatas()async{
    try {

      final res = await supabase.from('users').select('*').eq('uid',currentUser!.id).single();
      userDataComment.value=res;
      print(userDataComment.values);
      random;

    } catch (e) {
      print('Error fetching data: $e');
    }

  }
  
  getCommentData(
  {
    required int id,
}
      )async{
    try{
      final res=await supabase.from('comment').select('*').eq('video_id', id);
      commentDatas.value=res ?? [];
      random;
    }catch(e){
      print('Error fetching data: $e');
    }
    
  }


@override
  void onInit() {
  userdatas();
  Timer.periodic(Duration(seconds:2),(_)=> random) ;

    super.onInit();
  }


}