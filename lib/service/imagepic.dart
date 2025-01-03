

import 'dart:io';

import 'package:image_picker/image_picker.dart';

imagePicker(ImageSource sources)async{
  final ImagePicker imagePicker=ImagePicker();
 XFile? image=await imagePicker.pickImage(source: sources);
 if(image!=null){
   return image.readAsBytes();
 }
 print('image is Not Selected');
}

videoPicker(ImageSource sources)async{
  final ImagePicker imagePicker=ImagePicker();
  XFile? image=await imagePicker.pickVideo(source: sources);
  if(image!=null){
    return File(image.path);
  }
  print('image is Not Selected');
}