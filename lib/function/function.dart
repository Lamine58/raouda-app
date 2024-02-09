import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

primaryColor() {
  return const Color(0xff044314);
}

paddingTop(height){
  return SizedBox(height: height.toDouble());
}

paddingLeft(width){
  return SizedBox(width: width.toDouble());
}

logo(width){
  return Image.asset('assets/images/logo.png',width: width.toDouble());
}

statusBar(){
  return AppBar(
    toolbarHeight: 0,
    elevation: 0,
    backgroundColor: primaryColor(),
  );
}

Future<File> compressImage(String imagePath, {int targetSize = 0}) async {
  File compressedImage;
  int quality = 100;

  do {
    var compressedData = await FlutterNativeImage.compressImage(
      imagePath,
      quality: quality,
    );

    compressedImage = File(compressedData.path);

    if (targetSize > 0 && compressedImage.lengthSync() > targetSize) {
      quality -= 10; // Decrease quality by 10 units if the size is still too large
    }
  } while (targetSize > 0 && compressedImage.lengthSync() > targetSize && quality > 0);

  return compressedImage;
}

String dateLang(String dateString, String lang) {
  DateTime dateTime = DateTime.parse(dateString);

  switch (lang) {
    case 'Français':
      return formatDate(dateTime, 'fr_FR');
    case 'English':
      return formatDate(dateTime, 'en_US');
    default:
      return formatDate(dateTime, 'fr_FR');
  }
}

String formatDate(DateTime dateTime, String locale) {
  initializeDateFormatting();
  return  DateFormat.yMMMMEEEEd(locale).format(dateTime);
}

ImageChannel(channel){

  if(channel=="WAVECI"){
    return Image.asset('assets/images/wave.png',height:70);
  }else if(channel=="OMCIV2"){
    return Image.asset('assets/images/om.png',height:70);
  }else if(channel=="MOMOCI"){
    return Image.asset('assets/images/momo.png',height:70);
  }else if(channel=="FLOOZ"){
    return Image.asset('assets/images/moov.png',height:70);
  }
}

grayColor() {
  return Color.fromARGB(255, 196, 196, 196);
}