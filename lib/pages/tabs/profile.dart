import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_app/auth/login.dart';

import '../../backend_service/auth_service/register.dart';
import '../../backend_service/auth_service/userdata.dart';


class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final userdatas=Get.put(Userdata());
  final register=Get.put(RegisterUser());



  @override
  void initState() {
    userdatas.getUserData();
    userdatas.currentUserContent();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Obx((){
                return Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:NetworkImage(userdatas.userdata['profile_url']),
                      radius:70,
                    ),
                    SizedBox(height:20,),
                    Text(userdatas.userdata['email']),
                    SizedBox(height:20,),
                    Text(userdatas.userdata['username']),
                    SizedBox(height:20,),
                    ElevatedButton(
                        onPressed:(){
                          register.logout();
                        },
                        child:const Text('Logout')),
                    SizedBox(height:50,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children:[
                        Column(
                          children: [
                            Text('Videos'),
                            Obx(()=>Text(userdatas.userVideo.length.toString())),
                          ],
                        ),

                        Column(
                          children: [
                            Text('Reels'),
                            Obx(()=>Text(userdatas.userReels.length.toString())),
                          ],
                        ),


                        Column(
                          children: [
                            Text('Post'),
                            Obx(()=>Text(userdatas.userPost.length.toString())),
                          ],
                        ),

                      ],
                    ),
                    SizedBox(height:30,),
                    Divider(color:Colors.white24,),
                    SizedBox(height:30,),
                    Align(
                        alignment:Alignment.topLeft,
                        child: Text('Video : '),
                    ),
                    SizedBox(height:30,),
                    ListView.builder(
                        physics:NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        itemCount:userdatas.userVideo.length,
                        itemBuilder:(context,index){
                          userdatas.currentUserContent();
                          final data=userdatas.userVideo[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:Column(
                              crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:MediaQuery.of(context).size.width,
                                  height:300,
                                  decoration:BoxDecoration(
                                    image:DecorationImage(
                                        image:NetworkImage(
                                            data['thumbnail']
                                        ),
                                      fit:BoxFit.fill
                                    )
                                  ),
                                child:Column(
                                  crossAxisAlignment:CrossAxisAlignment.end,
                                  children: [
                                    PopupMenuButton(
                                        itemBuilder:(context)=>[
                                          PopupMenuItem(
                                              child:const Text('Delete'),
                                            onTap:(){
                                                userdatas.deleteVideo(id:data['id']);
                                                userdatas.userVideo;
                                            },
                                          ),
                                        ]
                                    )
                                  ],
                                ),
                                ),
                                SizedBox(height:20,),
                                Text(data['des']),
                                SizedBox(height:20,),
                                Divider(),
                                SizedBox(height:20,),
                              ],
                            )
                          );
                        }
                    ),

                    Align(
                      alignment:Alignment.topLeft,
                      child: Text('Post : '),
                    ),
                    SizedBox(height:30,),
                    userdatas.userPost.isNotEmpty? ListView.builder(
                        physics:NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        itemCount:userdatas.userPost.length,
                        itemBuilder:(context,index){
                          final data=userdatas.userPost[index];
                          return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:MediaQuery.of(context).size.width,
                                    height:300,
                                    decoration:BoxDecoration(
                                        image:DecorationImage(
                                            image:NetworkImage(
                                                data['post_url']
                                            ),
                                            fit:BoxFit.fill
                                        )
                                    ),
                                    child:Column(
                                      crossAxisAlignment:CrossAxisAlignment.end,
                                      children: [
                                        PopupMenuButton(
                                            itemBuilder:(context)=>[
                                              PopupMenuItem(
                                                child:const Text('Delete'),
                                                onTap:(){
                                                  userdatas.deletePost(id:data['id']);
                                                  userdatas.userPost;
                                                },
                                              ),
                                            ]
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height:20,),
                                  Text(data['title']),
                                  SizedBox(height:20,),
                                  Text(data['des']),
                                  SizedBox(height:20,),
                                ],
                              )
                          );
                        }
                    ):Text('Null Data Post'),

                  ],
                );
              })
            ),
          ),
        ),
      )
    );
  }
}
