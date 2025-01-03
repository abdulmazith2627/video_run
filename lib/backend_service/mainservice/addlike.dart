

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../widget/snackbar.dart';

class AddLike extends GetxController{
  final supaBase=Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  var getlikeData=[].obs;
  var isliked=false.obs;


  Future<void> likeUser({required String uid, required String user_id, required int id}) async {
    try {
      await supaBase.from('like').insert(
          {'channel': uid,
            'users': user_id,
            'reels_id':id
          }
      );
      getlikeData;
      getLike(uid: id);
      isliked.value=true;
      print('Done to like');

    } catch (e) {
      showSnackBar('Error', 'Subscription failed: $e');
    }
  }


  Future<void> deleteLike({required String uid, required String user_id, required int id}) async {
    try {
      await supaBase.from('like').delete().match({
        'channel': uid,
        'users': user_id,
        'reels_id':id
      });
      getLike(uid: id);
      getlikeData;
      isliked.value=false;
    } catch (e) {
      showSnackBar('Error', 'Unsubscribe failed: $e');
    }
  }

  Future<void> getLike({required int uid}) async {
    try {
      final res = await supaBase.from('like').select().eq('reels_id', uid);
      getlikeData.value = res;

      // Update `isliked` based on current user's like
      isliked.value = res.any((like) => like['users'] == currentUser?.id);
      print('Like Data: $getlikeData');
    } catch (e) {
      showSnackBar('Error', 'Failed to fetch likes: $e');
      print(e);
    }
  }


}