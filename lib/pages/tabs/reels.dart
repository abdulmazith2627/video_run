import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:video_player/video_player.dart';

import '../../backend_service/mainservice/addlike.dart';
import '../../backend_service/mainservice/addreels_comment.dart';
import '../../backend_service/mainservice/getdata.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  VideoPlayerController? videoPlayerController;
  final reelsdata = Get.put(GetUserData());
  final addlike=Get.put(AddLike());
 final  TextEditingController _comment =TextEditingController();
  final addcomment=Get.put(reelsComment());
  @override
  void initState() {
    super.initState();
    if (reelsdata.reelsData.isNotEmpty) {
      playVideo(reelsdata.reelsData[0]['reels']);
    }

  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    _comment.dispose();
    super.dispose();
  }

  void playVideo(String video) {
    videoPlayerController?.dispose();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(video))
      ..initialize().then((_) {
        setState(() {
          videoPlayerController!.play();
          videoPlayerController!.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    addcomment.userdatas();
    reelsdata.reelsData;
    addlike.getlikeData;

    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: reelsdata.reelsData.length,
        onPageChanged: (index) {
          final reels = reelsdata.reelsData[index];
          playVideo(reels['reels']);
          addlike.getLike(uid: reels['id']); // Fetch like data for the current video
          addcomment.getCommentData(id: reels['id']);
        },
        itemBuilder: (context, index) {
          final reels = reelsdata.reelsData[index];
          addcomment.getCommentData(id:reels['id']);
          addlike.getLike(uid:reels['id']);
          userComments(){
            final comment=_comment.text;
            addcomment.addComments(
                uid:reels['uid'],
                username:addcomment.userdata['username'],
                profile:addcomment.userdata['profile_url'] ,
                comment: comment,
                user_uid: addcomment.userdata['uid'],
                id: reels['id']
            );
          }
          return Stack(
            children: [
              // Video Player
              videoPlayerController != null &&
                  videoPlayerController!.value.isInitialized
                  ? VideoPlayer(videoPlayerController!)
                  : const Center(child: CircularProgressIndicator()),

              // Bottom Information
              Positioned(
                bottom: 20,
                left: 10,
                right: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(reels['profile']),
                          radius: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          reels['username'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      reels['title'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      reels['des'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Positioned(
                bottom: 20,
                right: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(() {
                      final likeCount = addlike.getlikeData.length; // Number of likes for the current video
                      return Column(
                        children: [
                          IconButton(
                            onPressed: addlike.isliked.value
                                ? null
                                : () => addlike.likeUser(
                              uid: reels['uid'],
                              user_id: addlike.currentUser!.id,
                              id: reels['id'],
                            ),
                            icon: Icon(
                              Icons.thumb_up,
                              color: addlike.isliked.value ? Colors.blue : Colors.white,
                            ),
                          ),
                          Text('$likeCount', style: const TextStyle(color: Colors.white)),
                        ],
                      );
                    }),

                    const SizedBox(height: 70),
                    IconButton(
                      onPressed: () {
                        addlike.deleteLike(
                            uid:reels['uid'],
                            user_id:addlike.currentUser!.id,
                            id:reels['id']
                        );
                      },
                      icon: const Icon(Icons.thumb_down, color: Colors.white),
                    ),
                    const SizedBox(height: 70),
                    IconButton(
                      onPressed: () {
                        addcomment.getCommentData(id: reels['id']);
                        Get.bottomSheet(
                           backgroundColor:Colors.black,
                            Container(
                              child:Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Comment',
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Expanded(child: Container()),
                                        IconButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon: Icon(Icons.cancel, size: 30),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Divider(color: Colors.white12),


                                    Expanded(
                                        child:Obx((){
                                          return ListView.builder(
                                            itemCount:addcomment.commentDatas.length,
                                            itemBuilder: (context, index) {
                                              final comment =addcomment.commentDatas[index];
                                              addcomment.commentDatas;
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration:BoxDecoration(
                                                      color: Colors.white24,
                                                      borderRadius:BorderRadius.circular(10)
                                                  ),
                                                   child:Padding(
                                                     padding: const EdgeInsets.all(15.0),
                                                     child: Column(
                                                       crossAxisAlignment:CrossAxisAlignment.start,
                                                       children: [
                                                         Row(
                                                           children: [
                                                             CircleAvatar(backgroundImage:NetworkImage(comment['profile']),),
                                                             SizedBox(width:10,),
                                                             Text(comment['username']),
                                                             Expanded(child: Container()),
                                                             PopupMenuButton(itemBuilder:(context)=>[
                                                               PopupMenuItem(
                                                                   child:const Text('Delete'),
                                                                   onTap:(){

                                                                     addcomment.deleteCom(id:comment['id']);
                                                                     addcomment.commentDatas;
                                                                   },
                                                               )
                                                             ]),
                                                           ],
                                                         ),
                                                         
                                                         Text(comment['comment'])
                                                       ],
                                                     ),
                                                   ),
                                                ),
                                              );
                                            },
                                          );
                                        })
                                    ),
                                    Container(
                                      color: Colors.grey[900],
                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller:_comment,
                                              decoration: InputDecoration(
                                                hintText: "Type your comment here",
                                                hintStyle: TextStyle(color: Colors.white54),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  borderSide: BorderSide.none,
                                                ),
                                                filled: true,
                                                fillColor: Colors.grey[800],
                                              ),
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                            icon: Icon(Icons.send, color: Colors.blue),
                                            onPressed: () {
                                              if(_comment.text.isNotEmpty){
                                                userComments();
                                                _comment.clear();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                      icon: const Icon(Icons.comment, color: Colors.white),
                    ),
                    const SizedBox(height: 70),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                            image:NetworkImage(reels['profile']),
                            fit:BoxFit.fill
                        ),
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


