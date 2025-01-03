import 'package:get/get.dart';

showSnackBar(title,message){
  Get.showSnackbar(
      GetSnackBar(
        title:title,
        message:message,
        showProgressIndicator:true,
        duration:const Duration(seconds:2),
      )
  );
}