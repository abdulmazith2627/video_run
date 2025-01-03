import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youtube_app/auth/login.dart';
import 'package:youtube_app/service/imagepic.dart';
import 'package:youtube_app/widget/form.dart';
import 'package:youtube_app/widget/snackbar.dart';

import '../backend_service/auth_service/register.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
   final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  final TextEditingController _username=TextEditingController();
  Uint8List? _image;
   final signUpUserData=Get.put(RegisterUser());
  // pick image form users
  void imageSelect()async{
   Uint8List image=await imagePicker(ImageSource.gallery);
  setState(() {
    _image=image;
  });
  }

   void signUp(){
     final email=_email.text.trim();
     final password=_password.text.trim();
     final username=_username.text.trim();
     final image=_image!;
     signUpUserData.signUpUser(
       profile:image,
       email: email,
       password: password,
       username: username,
     );

   }

    @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _username.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
            child:Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  crossAxisAlignment:CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.slow_motion_video,
                      size:150,
                      color:Colors.redAccent,
                    ),
                    SizedBox(height:40,),

                    GestureDetector(
                      onTap:(){
                        imageSelect();
                      },
                      child: _image!=null?CircleAvatar(
                          radius:50,
                         backgroundColor:Colors.redAccent,
                          backgroundImage:MemoryImage(_image!)
                      ):CircleAvatar(
                          radius:50,
                          backgroundColor:Colors.redAccent,
                          backgroundImage:AssetImage('assets/blank.png')

                      )
                    ),

                    SizedBox(height:40,),
                    FormText(
                        controller:_email,
                        hint:'email@gmail.com',
                        isPass: false,
                        isFilled:true,
                      max: 1,
                    ),
                    SizedBox(height:40,),
                    FormText(
                        controller:_password,
                        hint:'* * *  * * *',
                        isPass: true,
                        isFilled:true,
                      max: 1,
                    ),

                    SizedBox(height:40,),
                    FormText(
                        controller:_username,
                        hint:'Username',
                        isPass:false,
                        isFilled:true,
                      max: 1,
                    ),
                    SizedBox(height:40,),
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
                        if(_email.text.isNotEmpty||_password.text.isNotEmpty||_username.text.isNotEmpty){
                         if(_email.text.isEmail){
                           if(_image==null){
                             showSnackBar('Error','upload your profile ');
                           }
                           signUp();
                           _email.clear();
                           _password.clear();
                           _username.clear();
                           setState(() {
                             _image=null;
                           });
                           Get.to(()=>LoginPage());
                         }else{
                           showSnackBar('Error','Enter valid email');
                         }
                        }else{
                          showSnackBar('Error','fill your details');
                        }
                        },
                        child:const Text('Signup Now')
                    ),
                    SizedBox(height:30,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text("Already have a Account? "),
                        TextButton(
                            style:TextButton.styleFrom(
                                foregroundColor:Colors.redAccent
                            ),
                            onPressed:(){
                              Get.back();
                            },
                            child:const Text('login')
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}