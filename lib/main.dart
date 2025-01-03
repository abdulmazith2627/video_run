import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_app/auth/login.dart';
import 'package:youtube_app/pages/connectionpage.dart';

import 'backend_service/auth_service/register.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Supabase.initialize(
      url:'https://vrzrhhmnfyhbnrxggnsb.supabase.co',
      anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZyenJoaG1uZnloYm5yeGdnbnNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0NDM1MjUsImV4cCI6MjA1MTAxOTUyNX0.leXLsVO-GgF_MgdeqXCGWb1L54FRVMNJGR3MR3y2vVs'
  );
  await Hive.openBox('userdata');
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final loginUser=Get.put(RegisterUser());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner:false,
      home: FutureBuilder(
          future:loginUser.haveData(),
          builder:(context,snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Scaffold(
                body:Center(
                  child:CircularProgressIndicator(),
                ),
              );
            }
            else if(snapshot.hasData){
              return ConnectionPage();
            }
            return LoginPage();
          }
      )
    );

  }
}

