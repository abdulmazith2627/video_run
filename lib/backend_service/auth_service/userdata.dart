

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../mainservice/addcomment.dart';
import '../mainservice/getdata.dart';

class Userdata extends GetxController {
  final supabase = Supabase.instance.client;
  final currentUser = Supabase.instance.client.auth.currentUser;
  final getdata = Get.put(GetUserData());
  final comment = Get.put(AddComment());

  var userdata = {}.obs;
  var userVideo = [].obs;
  var userReels = [].obs;
  var userPost = [].obs;

  getUserData() async {
    try {
      final res = await supabase.from('users').select().eq('uid', currentUser!.id).single();
      userdata.value = res;
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  currentUserContent() async {
    try {
      final resV = await supabase.from('video').select().eq('uid', currentUser!.id);
      final resR = await supabase.from('reel').select().eq('uid', currentUser!.id);
      final resP = await supabase.from('post').select().eq('uid', currentUser!.id);
      userVideo.value = resV ?? [];
      userReels.value = resR ?? [];
      userPost.value = resP ?? [];
    } catch (e) {
      print('Error fetching content: $e');
    }
  }

  deleteVideo({required int id}) async {
    try {
      // Delete video and related comments
      await supabase.from('video').delete().match({'id': id, 'uid': currentUser!.id});
      await supabase.from('comment').delete().match({'id': id, 'users_id': currentUser!.id});

      // Update local data
      userVideo.removeWhere((video) => video['id'] == id);
      getdata.videoData.removeWhere((video) => video['id'] == id);

      // Refresh dependent controllers
      getdata.fetchAllData();
    } catch (e) {
      print('Error deleting video: $e');
    }
  }



  deletePost({required int id}) async {
    try {
      // Delete video and related comments
      await supabase.from('post').delete().match({'id': id, 'uid': currentUser!.id});

      // Update local data
      userPost.removeWhere((post) => post['id'] == id);
      getdata.postData.removeWhere((post) => post['id'] == id);

      // Refresh dependent controllers
      getdata.fetchAllData();
    } catch (e) {
      print('Error deleting video: $e');
    }
  }

  deleteReel({required int id}) async {
    try {
      // Delete video and related comments
      await supabase.from('reel').delete().match({'id': id, 'uid': currentUser!.id});
      await supabase.from('reels_comment').delete().match({'id': id, 'user_id': currentUser!.id});

      // Update local data
      userReels.removeWhere((video) => video['id'] == id);
      getdata.reelsData.removeWhere((video) => video['id'] == id);

      // Refresh dependent controllers
      getdata.fetchAllData();
    } catch (e) {
      print('Error deleting video: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUserData();
    currentUserContent();
  }
}
