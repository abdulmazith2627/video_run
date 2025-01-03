import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import '../../backend_service/mainservice/addcontent.dart';
import '../../service/imagepic.dart';
import '../../widget/form.dart';

class ReelsAdd extends StatefulWidget {
  const ReelsAdd({super.key});

  @override
  State<ReelsAdd> createState() => _ReelsAddState();
}

class _ReelsAddState extends State<ReelsAdd> {
  final TextEditingController _title=TextEditingController();
  final TextEditingController _des=TextEditingController();
  VideoPlayerController? _videoPlayerController;
  final addreels=Get.put(AddContent());
  File? _vedio;

  void pickvideo()async{
    File? video =await videoPicker(ImageSource.gallery);
    setState(() {
      _vedio=video;
    });
    final showVideo=VideoPlayerController.file(_vedio!)
      ..initialize();
    setState(() {

      _videoPlayerController=showVideo;
      _videoPlayerController!.play();
      _videoPlayerController!.setLooping(true);
    });

  }

  void addReels(){
    final video=_vedio!;
    final title=_title.text;
    final des=_des.text;
    addreels.addReels(video: video, title: title, des: des);
  }

  @override
  void dispose() {
    _title.dispose();
    _des.dispose();
    _videoPlayerController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:const Text('Add Reels'),),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SafeArea(
              child:SingleChildScrollView(
                child:Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onLongPress:(){
                          Get.defaultDialog(
                              title:'Remove your content',
                              content:ElevatedButton(onPressed:(){
                                setState(() {
                                  _videoPlayerController!.dispose();
                                  _vedio=null;
                                  _videoPlayerController=null;
                                });
                                Get.back();
                              }, child:const Text('Remove'))
                          );
                        },

                        onTap:(){
                          pickvideo();
                        },
                        child:_videoPlayerController==null?Container(
                          width:MediaQuery.of(context).size.width,
                          height:250,
                          color:Colors.white12,
                          child:Center(child:Text('Video'),),
                        ):AspectRatio(
                          aspectRatio:_videoPlayerController!.value.aspectRatio,
                          child:VideoPlayer(_videoPlayerController!),
                        )
                    ),
                    SizedBox(height:25,),
                    FormText(
                      controller:_title,
                      hint:'Enter Title',
                      isPass: false,
                      isFilled: true,
                      max: 1,
                    ),


                    SizedBox(height:25,),
                    FormText(
                      controller:_des,
                      hint:'Enter description',
                      isPass: false,
                      isFilled: true,
                      max: 7,
                    ),
                    SizedBox(height:25,),
                    ElevatedButton(
                      style:ElevatedButton.styleFrom(
                          backgroundColor:Colors.redAccent,
                          foregroundColor:Colors.white,
                          shape:RoundedRectangleBorder(
                            borderRadius:BorderRadius.circular(10),
                          ),
                          fixedSize:Size(350,50)
                      ),
                      onPressed:(){
                        addReels();
                        setState(() {
                          _videoPlayerController!.dispose();
                          _videoPlayerController=null;
                          _vedio=null;
                          _title.clear();
                          _des.clear();
                        });
                        Get.back();
                      },
                      child:const Text('publish reels'),
                    ),
                    SizedBox(height:50,)
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
