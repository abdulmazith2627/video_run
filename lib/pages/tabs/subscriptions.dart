import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../backend_service/mainservice/getsub.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final subs=Get.put(getSubs());
  @override
  void initState() {
    subs.getSubscribeData();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Obx((){
        return subs.subUser.isNotEmpty?ListView.builder(
            itemCount:subs.subUser.length,
            scrollDirection:Axis.horizontal,
            itemBuilder:(context,index){
              final user=subs.subUser[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage:NetworkImage(user['profile']),
                      radius:50,
                    ),
                    SizedBox(height:20,),
                    Text(user['username'])
                  ],
                ),
              );
            }
        ):Container();
      })
    );
  }
}
