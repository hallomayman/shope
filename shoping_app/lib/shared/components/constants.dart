import 'package:flutter/material.dart';
import 'package:shoping_app/modules/shop_app/log_in/log_in.dart';
import 'package:shoping_app/network/local/cash_helper.dart';

Color darkMod = Color.fromRGBO(51, 55, 57, 1);

void signOut(context){
  CashHelper.clearData(key: 'token').then((value) {
    token = '';
    if (value) {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => ShopLoginScreen()),(Route<dynamic> route) => false);
    }

  });
}

void printFULLTEXT(String text){
  final pattern = RegExp('1,{800}');
  pattern.allMatches(text).forEach((match)=> print(match.group(0)));
}

String token = '';

