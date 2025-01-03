import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:youtube_app/backend_service/mainservice/addcomment.dart';
import 'package:youtube_app/pages/subpage/playvideo.dart';

import '../../backend_service/auth_service/userdata.dart';
import '../../backend_service/mainservice/addcontent.dart';
import '../../backend_service/mainservice/addsub.dart';
import '../../backend_service/mainservice/getdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final userdata=Get.put(GetUserData());
  final user=Get.put(AddContent());
  final sub=Get.put(Subs());
  final comment=Get.put(AddComment());
  final userinfoData=Get.put(Userdata());
  @override
  void initState() {
    userdata.fetchAllData();
    Timer.periodic(Duration(minutes:2),(_)=> userdata.fetchAllData());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:const Text('Run Videos'),
      ),
      body:SingleChildScrollView(
        child: Obx((){
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
                           padding: const EdgeInsets.all(20.0),
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
                           padding: const EdgeInsets.all(20.0),
                           child: Column(
                             children: [
                               GestureDetector(
                                 onTap:(){
                                   Get.to(()=>PlayVideo(
                                       video_url:allUserData['video'],
                                       des:allUserData['des'],
                                       title:allUserData['title'],
                                     data:DateFormat('yyyy-MM-dd').format(
                                         DateTime.parse(allUserData ['created_at'])
                                     ).toString(),
                                     username:allUserData['username'] ,
                                     profile:allUserData['profile'],
                                     uid:allUserData['uid'],
                                     id:allUserData['id']
                                   ));
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
                                     backgroundImage:NetworkImage(allUserData['profile']),
                                   ),
                                   SizedBox(width:10,),
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment:CrossAxisAlignment.start,
                                       children: [
                                         Text(allUserData['des'],maxLines:2,overflow:TextOverflow.visible,),
                                         Row(
                                           children: [
                                             Text(allUserData['username']),
                                            SizedBox(width:10,),
                                             Text(
                                               (DateFormat('yyyy-MM-dd').format(
                                                   DateTime.parse(userdata.userData[0]['created_at'])
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
      )
    );
  }
}



