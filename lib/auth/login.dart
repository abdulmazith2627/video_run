import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_app/auth/signup.dart';
import 'package:youtube_app/widget/form.dart';
import 'package:youtube_app/widget/snackbar.dart';

import '../backend_service/auth_service/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email=TextEditingController();
  final TextEditingController _password=TextEditingController();
  final loginUserData=Get.put(RegisterUser());
  void login(){
    final email=_email.text.trim();
    final password=_password.text.trim();
    loginUserData.loginUser(email: email, password: password);
  }
      @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
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
                      size:300,
                      color:Colors.redAccent,
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

                    SizedBox(height:30,),
                    
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
                         if(_email.text.isNotEmpty&&_password.text.isNotEmpty){
                            if(_email.text.isEmail){
                              login();
                              _email.clear();
                              _password.clear();
                            }else{
                              showSnackBar('Error','Enter valid email');
                            }

                          }else{
                            showSnackBar('Error','Enter your details to login');
                          }
                          },
                        child:const Text('Login Now')
                    ),
                    SizedBox(height:30,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text("Create a New Account? "),
                        TextButton(
                            style:TextButton.styleFrom(
                                foregroundColor:Colors.redAccent
                            ),
                            onPressed:(){
                             Get.to(()=>Signup());
                            },
                            child:const Text('Signup')
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