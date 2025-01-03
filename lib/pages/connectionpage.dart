import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_app/pages/addservice/addreels.dart';
import 'package:youtube_app/pages/tabs/homepage.dart';
import 'package:youtube_app/pages/tabs/profile.dart';
import 'package:youtube_app/pages/tabs/reels.dart';
import 'package:youtube_app/pages/tabs/subscriptions.dart';


import '../backend_service/auth_service/userdata.dart';
import '../backend_service/mainservice/getdata.dart';
import 'addservice/addpost.dart';
import 'addservice/addvideo.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  Widget currentPage=const HomePage();
  int currentIndex=0;
  final userdatas=Get.put(Userdata());
  final PageStorageBucket pageStorageBucket=PageStorageBucket();

  @override
  void initState() {
     userdatas.getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PageStorage(
          bucket:pageStorageBucket,
          child: currentPage,
      ),
      bottomNavigationBar:BottomAppBar(
        height:70,
        child:Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed:(){

                  setState(() {
                    currentPage=HomePage();
                    currentIndex=0;
                  });
                },
                icon: Icon(Icons.home,color:currentIndex==0?Colors.redAccent:Colors.grey,)
            ),
            SizedBox(width:10,),
            IconButton(
                onPressed:(){
                  setState(() {
                    currentPage=ReelsPage();
                    currentIndex=1;
                  });
                },
                icon:Image(
                    image:AssetImage('assets/shorts.png'),
                    color:currentIndex==1?Colors.redAccent:Colors.grey
                ),
            ),
           SizedBox(width:10,),
           GestureDetector(
             onTap:(){
               Get.defaultDialog(
                 title:'Select What you want',
                 content:Column(
                   children: [
                     GestureDetector(
                       onTap:(){
                         Get.to(()=>ReelsAdd());
                       },
                       child: Container(
                         width:MediaQuery.of(context).size.width,
                         height:70,
                         decoration:BoxDecoration(
                           color:Colors.white10,
                           borderRadius:BorderRadius.circular(10),
                         ),
                         child:Center(child:Text('Reels'),),
                       ),
                     ),
                     SizedBox(height:20,),

                     GestureDetector(
                       onTap:(){
                         Get.to(()=>const AddVideos());
                       },
                       child: Container(
                         width:MediaQuery.of(context).size.width,
                         height:70,
                         decoration:BoxDecoration(
                           color:Colors.white10,
                           borderRadius:BorderRadius.circular(10),
                         ),
                         child:Center(child:Text('Video'),),
                       ),
                     ),
                     SizedBox(height:20,),


                     GestureDetector(
                       onTap:(){
                         Get.to(()=>AddPost());
                       },
                       child: Container(
                         width:MediaQuery.of(context).size.width,
                         height:70,
                         decoration:BoxDecoration(
                           color:Colors.white10,
                           borderRadius:BorderRadius.circular(10),
                         ),
                         child:Center(child:Text('Post'),),
                       ),
                     ),
                     SizedBox(height:20,),
                     GestureDetector(
                       onTap:(){Get.back();},
                       child: Container(
                         width:MediaQuery.of(context).size.width,
                         height:70,
                         decoration:BoxDecoration(
                           color:Colors.black54,
                           borderRadius:BorderRadius.circular(10),
                         ),
                         child:Center(child:Text('Cancel'),),
                       ),
                     ),
                     SizedBox(height:20,),
                   ],
                 )
               );
             },
             child: Container(
               width:50,
               height:70,
               decoration:BoxDecoration(
                 shape:BoxShape.circle,
                 color:Colors.white12,

               ),
               child:Icon(Icons.add),
             ),
           ),

            IconButton(
                onPressed:(){
                  setState(() {
                    currentPage=Subscriptions();
                    currentIndex=2;
                  });

                },
                icon: Icon(Icons.subscriptions_outlined,color:currentIndex==2?Colors.redAccent:Colors.grey)
            ),
            SizedBox(width:10,),
            IconButton(
                onPressed:(){
                  setState(() {
                    currentPage=Profile();
                    currentIndex=3;
                  });


                },
                icon: Obx(()=>
                userdatas.userdata['profile_url']!=null?CircleAvatar(
                  backgroundImage:NetworkImage(userdatas.userdata['profile_url']),
                  radius:30,
                ):CircleAvatar(
                  radius:30,
                )
                )
            ),


          ],
        ),
      ),
    );
  }
}
