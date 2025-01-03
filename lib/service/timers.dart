import 'dart:async';
import 'package:get/get.dart';
import 'package:youtube_app/widget/snackbar.dart';

class Timing extends GetxController{
  var remainingTime=60.obs;
  Timer? _timer;

  void getStartingTime(){
    _timer=Timer.periodic(Duration(seconds:1),(timer){
      if(remainingTime>0){
        remainingTime.value--;
      }else{
        _timer!.cancel();
      }
    }
    );
  }


    void resendOtp(){
     remainingTime.value=60;
     getStartingTime();
     showSnackBar('SuccessFully','Done to send again otp, So check your given email',);
    }

  @override
  void onClose() {
    _timer!.cancel();
    super.onClose();
  }

}