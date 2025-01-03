import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../backend_service/mainservice/addcomment.dart';
import '../../backend_service/mainservice/addsub.dart';
import '../../backend_service/mainservice/getdata.dart';

class PlayVideo extends StatefulWidget {
   PlayVideo({
    super.key,
    required this.video_url,
    required this.des,
    required this.title,
    required this.data,
    required this.username,
    required this.profile,
    required this.uid,
     required this.id
  });
 late  String video_url;
 late  String des;
 late  String title;
 late  String data;
 late  String username;
 late  String profile;
 late String uid;
 late int id;

  @override
  State<PlayVideo> createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  final TextEditingController _comment =TextEditingController();
  VideoPlayerController? _videoPlayerController;
  FlickManager? flickManager;
  final ScrollController _scrollController = ScrollController();
  final userdata = Get.put(GetUserData());
  final sub=Get.put(Subs());
  final userComment=Get.put(AddComment());



  var indexvalue=''.obs;

  void updataVideo(String video, String title, String des, String date, String username, String profile, int id) {
    _videoPlayerController?.dispose();


    setState(() {
      widget.video_url = video;
      widget.title = title;
      widget.des = des;
      widget.data = date;
      widget.username = username;
      widget.profile = profile;
      widget.id=id;

      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(video));

      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _videoPlayerController!.play();
        });
      });

      flickManager?.handleChangeVideo(_videoPlayerController!);
    });

  }

  void playVideo(String videoUrl) {
    setState(() {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _videoPlayerController!.play();
        });
      });
    });


    flickManager = FlickManager(videoPlayerController: _videoPlayerController!);
  }



  @override
  void initState() {
    super.initState();
    sub.getSub(uid:widget.uid);
    sub.isSubscribe(uid:widget.uid, user_id: userdata.currentUser!.id);
    playVideo(widget.video_url);
    userComment.getCommentData(id:widget.id);
    userComment.userdatas();

  }

  @override
  void dispose() {

    _videoPlayerController?.dispose();
    flickManager?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    sub.isSubscribe(uid:widget.uid, user_id: userdata.currentUser!.id);
    sub.getSub(uid:widget.uid);
    userComment.userdatas();
    userComment.getCommentData(id:widget.id);
    return Scaffold(
       body:SafeArea(
         child: SingleChildScrollView(
           controller:_scrollController,
           child: Column(
             crossAxisAlignment:CrossAxisAlignment.start,
             children: [
               SizedBox(height:20,),
              _videoPlayerController!=null? AspectRatio(
                   aspectRatio:_videoPlayerController!.value.aspectRatio
                ,
                  child:FlickVideoPlayer(flickManager: flickManager!),
               ):GestureDetector(
                onTap:(){print(widget.video_url);},
                 child: Container(
                  width:200,
                  height:200,
                  color:Colors.red,
                           ),
               ),
               Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: Expanded(
                   child: Column(
                     crossAxisAlignment:CrossAxisAlignment.start,
                     children: [
                       Text(widget.title),
                       Text(widget.des),
                       SizedBox(height:10,),
                       Text(widget.data,style:TextStyle(color:Colors.white24),),
                       SizedBox(height:10,),
                       Row(
                         children: [
                           CircleAvatar(
                             backgroundImage:NetworkImage(widget.profile),
                           ),
                           SizedBox(width:10,),
                           Text(widget.username),
                           SizedBox(width:10,),
                          Obx(()=> Text('${sub.numsListSub.length}',style:TextStyle(color:Colors.white24)),),

                           Expanded(child: Container()),
                           Obx(() => ElevatedButton(
                             style: ElevatedButton.styleFrom(
                               foregroundColor: Colors.white,
                               backgroundColor: sub.isSub.value == false ? Colors.redAccent : Colors.white24,
                             ),
                             onPressed: () async {
                               if (!sub.isSub.value) {

                                 await sub.subUser(uid: widget.uid, user_id: sub.currentUser!.id, profile:widget.profile, username:widget.username);
                               } else {
                                 await sub.deleteSub(uid: widget.uid, user_id: sub.currentUser!.id);
                               }
                             },
                             child: Text(sub.isSub.value == false ? 'Subscribe' : 'Unsubscribe'),
                           )),

                         ],
                       ),
                          SizedBox(height:30,),
                       GestureDetector(
                         onTap:(){
                           mycomment(){
                             final commentuser=_comment.text;
                             userComment.addComments(
                                 uid: widget.uid,
                                 username:userComment.userDataComment['username'],
                                 profile:userComment.userDataComment['profile_url'],
                                 comment:commentuser,
                                 user_uid:userComment.userDataComment['uid'],
                                 id: widget.id
                             );
                           }
                           Get.bottomSheet(
                             Container(
                               color: Colors.black,
                               width: MediaQuery.of(context).size.width,
                               height: MediaQuery.of(context).size.height,
                               child: Column(
                                 children: [
                                   Padding(
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
                                       ],
                                     ),
                                   ),
                                   Expanded(
                                     child: Obx((){
                                       return ListView.builder(
                                         itemCount:userComment.commentDatas.length,
                                         itemBuilder: (context, index) {
                                           final commentdata=userComment.commentDatas[index];
                                           return Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Container(
                                               width: MediaQuery.of(context).size.width,
                                               decoration:BoxDecoration(
                                                 color: Colors.white24,
                                                 borderRadius:BorderRadius.circular(10)
                                               ),
                                               child:Padding(
                                                 padding: const EdgeInsets.all(10.0),
                                                 child: Column(
                                                   crossAxisAlignment:CrossAxisAlignment.start,
                                                   children: [
                                                     Row(
                                                       mainAxisAlignment:MainAxisAlignment.start,
                                                       children: [
                                                         CircleAvatar(backgroundImage:NetworkImage(commentdata['profile']),),
                                                         Text("@${commentdata['username']}"),
                                                         SizedBox(width:10,),
                                                         Text(DateFormat('yyyy-MM-dd').format(
                                                             DateTime.parse(commentdata['created_at'])
                                                         ).toString(),style:TextStyle(fontSize:10),),
                                                         Expanded(child:Container()),
                                                         PopupMenuButton(
                                                             itemBuilder:(context)=>[
                                                               PopupMenuItem(
                                                                   child:const Text('delete'),
                                                                  onTap:(){
                                                                     userComment.deleteCom(
                                                                         id:commentdata['id'],
                                                                     );
                                                                  },
                                                               ),

                                                             ])
                                                       ],
                                                     ),

                                                     Text("${commentdata['comments']}"),

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


                                             mycomment();
                                              _comment.clear();


                                           },
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           );

                         },
                         child: Container(
                           width:MediaQuery.of(context).size.width,

                           decoration:BoxDecoration(
                             color:Colors.white10,
                             borderRadius:BorderRadius.circular(20),
                           ),
                           
                           child:Padding(
                             padding: const EdgeInsets.all(15.0),
                             child:Obx((){
                               userComment.getCommentData(id:widget.id);
                               return userComment.commentDatas.isNotEmpty?Column(
                                 children: [
                                   Row(
                                     children: [
                                       Text('Comments ${userComment.commentDatas.length}'),
                                     ],
                                   ),
                                   SizedBox(height:10,),
                                   Row(
                                     children: [
                                       CircleAvatar(backgroundImage:NetworkImage(userComment.commentDatas[0]['profile']),),
                                       SizedBox(width:10,),
                                       Text('@${userComment.commentDatas[0]['username']}',style:TextStyle(fontSize:10,color:Colors.grey),),
                                       SizedBox(width:5,),
                                       Text(' ${userComment.commentDatas[0]['comments']}',maxLines:1,overflow:TextOverflow.ellipsis,),
                                     ],
                                   )
                                 ],
                               ):Container(
                                 height:100,
                               );
                             })
                           ),
                         ),
                       ),
                       SizedBox(height:25,),
                       Obx((){
                         return Column(
                           children: [
                             SizedBox(
                               child: ListView.builder(
                                   physics:NeverScrollableScrollPhysics(),
                                   shrinkWrap:true,
                                   itemCount:userdata.allData.length,
                                   itemBuilder:(context,index){
                                     final allUserData=userdata.allData[index];
                                     if(allUserData['method']=='post'){
                                       return Padding(
                                         padding: const EdgeInsets.all(10.0),
                                         child: Container(
                                           width:MediaQuery.of(context).size.width,
                                           color:Colors.white10,
                                           child:Padding(
                                             padding: const EdgeInsets.all(20.0),
                                             child: Column(
                                               crossAxisAlignment:CrossAxisAlignment.start,
                                               children: [
                                                 Container(
                                                   width:MediaQuery.of(context).size.width,
                                                   height:300,
                                                   decoration:BoxDecoration(
                                                       image:DecorationImage(image:NetworkImage(allUserData['post_url']))
                                                   ),
                                                 ),

                                                 Text(allUserData['title']),
                                                 Text(allUserData['des']),
                                                 Row(
                                                   children: [
                                                     IconButton(
                                                         onPressed:(){},
                                                         icon:Icon(Icons.thumb_up)
                                                     ),

                                                     IconButton(
                                                       onPressed:(){},
                                                       icon:Icon(Icons.thumb_down),
                                                     ),
                                                     Text(
                                                       (DateFormat('yyyy-MM-dd').format(
                                                           DateTime.parse(allUserData ['created_at'])
                                                       )).toString(),
                                                     ),
                                                   ],
                                                 )
                                               ],
                                             ),
                                           ),
                                         ),
                                       );
                                     }

                                     else if(allUserData['method']=='video'){

                                       return Padding(
                                         padding: const EdgeInsets.all(10.0),
                                         child: Column(
                                           children: [
                                             GestureDetector(
                                               onTap:(){
                                                 updataVideo(
                                                     allUserData['video'],
                                                     allUserData['title'],
                                                     allUserData['des'],
                                                     DateFormat('yyyy-MM-dd').format(
                                                         DateTime.parse(allUserData ['created_at'])
                                                     ).toString(),
                                                     allUserData['username'],
                                                     allUserData['profile'],
                                                     allUserData['id']

                                                 );
                                                 _scrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);

                                               },
                                               child: Container(
                                                 width:MediaQuery.of(context).size.width,
                                                 height:250,
                                                 decoration:BoxDecoration(
                                                   color:Colors.green,
                                                   image:DecorationImage(
                                                     image:NetworkImage(allUserData['thumbnail'],),
                                                     fit:BoxFit.fill,
                                                     filterQuality:FilterQuality.high,
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(height:15,),
                                             Row(
                                               children: [

                                                 CircleAvatar(
                                                   backgroundImage:NetworkImage(allUserData['profile'],),
                                                 ),
                                                 SizedBox(width:10,),
                                                 Expanded(
                                                   child: Column(
                                                     crossAxisAlignment:CrossAxisAlignment.start,
                                                     children: [
                                                       Text(allUserData['des'],maxLines:2,overflow:TextOverflow.visible,),
                                                       Row(
                                                         children: [
                                                           Text(allUserData['username'],),
                                                           SizedBox(width:10,),
                                                           Text(
                                                             (DateFormat('yyyy-MM-dd').format(
                                                                 DateTime.parse(allUserData['created_at'])
                                                             )).toString(),
                                                           ),
                                                         ],
                                                       )

                                                     ],
                                                   ),
                                                 )
                                               ],
                                             )
                                           ],
                                         ),
                                       );
                                     }



                                   }
                               ),
                             ),
                           ],
                         );
                       }),
                     ],
                   ),
                 ),
               )
             ],
           ),
         ),
       ),
    );
  }

}
