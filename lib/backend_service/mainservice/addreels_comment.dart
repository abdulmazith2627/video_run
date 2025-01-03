

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widget/snackbar.dart';

class reelsComment extends GetxController{
  final supabase=Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  var userdata={}.obs;
  var commentDatas=[].obs;


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
      final res=await supabase.from('reels_comment').insert({
        'uid':uid,
        'user_uid':user_uid,
        'username':username,
        'comment':comment,
         'profile':profile,
        'reels_id':id
      });
      userdatas();
      getCommentData(id: id);
      print('comment done');

    }catch(e){
      showSnackBar('Error','addComment : $e');
      print(e);
    }
  }

  Future<void> deleteCom({
    required int id,
  }) async {
    try {

      await supabase.from('reels_comment').delete().eq('id', id);


      commentDatas.removeWhere((comment) => comment['id'] == id);

      userdatas();
    } catch (e) {
      showSnackBar('Error', 'Delete comment failed: $e');
      print('Error deleting comment: $e');
    }
  }


  getCommentData(
      {
        required int id,
      }
      )async{
    try{
      print('Id : $id');
      final res=await supabase.from('reels_comment').select('*').eq('reels_id', id);
      commentDatas.value=res ?? [];

    }catch(e){
      print('Error fetching data: $e');
    }

  }

  void userdatas()async{
    try {

      final res = await supabase.from('users').select('*').eq('uid',currentUser!.id).single();
      userdata.value=res;

    } catch (e) {
      print('Error fetching data: $e');
    }

  }
}