import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_app/widget/snackbar.dart';

import 'getsub.dart';

class Subs extends GetxController{
  final supaBase=Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  var isSub=false.obs;
  var numsListSub=[].obs;



  Future<void> subUser({required String uid,required String profile,required String username,required String user_id}) async {
    try {
      await supaBase.from('subscribe').insert({
        'uid': uid,
        'users_uid': user_id,
        'username':username,
        'profile':profile,
      });
      await isSubscribe(uid: uid, user_id: user_id);
      await getSub(uid: uid);

    } catch (e) {
      showSnackBar('Error', 'Subscription failed: $e');
    }
  }

  Future<void> deleteSub({required String uid, required String user_id}) async {
    try {
      await supaBase.from('subscribe').delete().match({'uid': uid, 'users_uid': user_id});
      await isSubscribe(uid: uid, user_id: user_id);
      await getSub(uid: uid);

    } catch (e) {
      showSnackBar('Error', 'Unsubscribe failed: $e');
    }
  }

 Future getSub(
  {
    required String uid,
}
     )async{
    try{
      final res=await supaBase.from('subscribe').select().eq('uid',uid);
      numsListSub.value=res;

    }catch(e){
      showSnackBar('Error','sub : $e');
      print(e);
    }
 }

  Future isSubscribe(
      {
        required String uid,
        required String user_id,
      }
      )async{
    try{
      final res=await supaBase.from('subscribe').select().match({'uid':uid,'users_uid':user_id});
     var getdata=res;
     if(getdata.isNotEmpty){
      isSub.value=true;
     }else{
       isSub.value=false;
     }
    }catch(e){
      showSnackBar('Error','sub : $e');
      print(e);
    }
  }


}