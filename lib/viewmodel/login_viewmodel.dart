import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../core/api_routes.dart';
import '../core/http.dart';
import '../view/menu_view.dart';

class LoginViewModel extends GetxController {
  final formKey = GlobalKey<FormState>();
  Rx<bool> rememberMeCheckValue = false.obs;

  ///Kullanıcı adı ve şifre TextEditingControlleri
  TextEditingController usernameController =
      TextEditingController(text: 'eve.holt@reqres.in');
  TextEditingController passwordController =
      TextEditingController(text: 'cityslicka');

  ///Controller'den gelen veri ile API'ye kullanıcı girişi isteği atar.
  login(context) async {
    Map loginValues = {
      //"username": username,
      "email": usernameController.text,
      "password": passwordController.text,
    };
    try {
      var response = await Http.post(
          requestLink: APIRoutesEnum.login.routeName,
          data: jsonEncode(loginValues));
      if (response.statusCode == 200) {
        var storage = const FlutterSecureStorage();
        await storage.write(
            key: 'token', value: jsonDecode(response.body)['token']);
        log(response.body);
        //API'den onay gelirse MenuView sayfasına yönlendirir.
        Get.offAll(const MenuView());
      } else {
        await Fluttertoast.showToast(
            gravity: ToastGravity.TOP,
            textColor: Colors.black,
            msg: "Hata ${jsonDecode(response.body)['error']}",
            backgroundColor: (Colors.grey));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Controller'den gelen veri ile API'ye kullanıcı kaydı isteği atar.
  ///KULLANILMIYOR
  register(context) async {
    Map registerValues = {
      //"username": username,
      "email": usernameController.text,
      "password": passwordController.text,
    };
    try {
      var response = await Http.post(
          requestLink: APIRoutesEnum.register.routeName,
          data: jsonEncode(registerValues));
      if (response.statusCode == 200) {
        var storage = const FlutterSecureStorage();
        await storage.write(
            key: 'token', value: jsonDecode(response.body)['token']);
        log(response.body);

        Get.offAll(const MenuView());
      } else {
        await Fluttertoast.showToast(
            msg: "Hata ${jsonDecode(response.body)['error']}",
            backgroundColor: (Colors.white));
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
