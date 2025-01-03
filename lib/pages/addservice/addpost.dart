import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_app/pages/tabs/homepage.dart';



import '../../backend_service/mainservice/addcontent.dart';
import '../../service/imagepic.dart';
import '../../widget/form.dart';
import '../../widget/snackbar.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _title=TextEditingController();
  final TextEditingController _des=TextEditingController();
  final addpost=Get.put(AddContent());
  Uint8List? _image;

  void pickPost()async{
    Uint8List image=await imagePicker(ImageSource.gallery);
    setState(() {
      _image=image;
    });
  }

   void addPosts(){
    final title=_title.text;
    final des=_des.text;
    addpost.addPost(
        post_image:_image!,
        title: title,
        des: des
    );
   }
  @override
  void dispose() {
 _title.dispose();
 _des.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:const Text('Add Post'),),
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
                      onTap:(){
                        pickPost();
                      },
                      child: _image==null?Container(
                        width:MediaQuery.of(context).size.width,
                        height:250,
                        color:Colors.white12,
                        child:Center(child:Icon(Icons.add,size:35,),),
                      ):Container(
                        width:MediaQuery.of(context).size.width,
                        height:300,
                        decoration:BoxDecoration(
                          image: DecorationImage(
                              image:MemoryImage(_image!),
                              fit:BoxFit.fill,
                            filterQuality:FilterQuality.high
                          )
                        ),
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
                          if(_title.text.isNotEmpty||_des.text.isNotEmpty){
                            addPosts();
                            _title.clear();
                            _des.clear();
                            setState(() {
                              _image=null;
                            });
                          }else{
                            showSnackBar("Error","Fill next to try push post");
                          }
                        },
                        child:const Text('add Post'),
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
