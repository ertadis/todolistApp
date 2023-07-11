import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../viewmodel/login_viewmodel.dart';
import 'widgets/custom_text_form_field_widget.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Login ekranında geri tuşuna basıldığında çıkacak uyarı ekranı
        Get.dialog(AlertDialog(
          content: const Text("Uygulamadan çıkılacak, emin misiniz?"),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Hayır"),
            ),
            ElevatedButton(
              onPressed: () {
                Platform.isAndroid ? SystemNavigator.pop() : exit(0);
              },
              child: const Text("Evet"),
            )
          ],
        ));
        return false;
      },
      child: GestureDetector(
        onTap: () {
          //Ekranda herhangi bir yere tıklayınca textFormField focusundan çıkartır.
          FocusScope.of(context).unfocus();
        },
        child: GetBuilder<LoginViewModel>(
            init: LoginViewModel(),
            builder: (c) {
              return SafeArea(
                child: Scaffold(
                  body: Column(
                    children: [
                      Expanded(
                          flex: 4,
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              child: Image.asset('assets/logo.png'))),
                      Expanded(
                        flex: 8,
                        child: Form(
                          key: c.formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomTextFormField(
                                  c: c,
                                  controller: c.usernameController,
                                  labelText: 'Kullanıcı Adı'),
                              CustomTextFormField(
                                  c: c,
                                  controller: c.passwordController,
                                  labelText: 'Parola'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Beni Hatırla'),
                                  Obx(() => Checkbox(
                                        value: c.rememberMeCheckValue.value,
                                        onChanged: (value) {
                                          //Beni hatırla butonu
                                          c.rememberMeCheckValue.value =
                                              !c.rememberMeCheckValue.value;
                                          var storage =
                                              const FlutterSecureStorage();
                                          storage.write(
                                              key: 'rememberMe',
                                              value:
                                                  c.rememberMeCheckValue.value
                                                      ? 'true'
                                                      : 'false');
                                        },
                                      )),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: FloatingActionButton(
                    heroTag: 'login',
                    onPressed: () {
                      if (c.formKey.currentState!.validate()) {
                        c.formKey.currentState!.save();
                        c.login(context);
                      }
                    },
                    child: const Icon(Icons.login),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
