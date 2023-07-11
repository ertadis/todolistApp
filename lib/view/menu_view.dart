import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../viewmodel/menu_viewmodel.dart';
import 'todolist_view.dart';
import 'userlist_view.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

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
          //Ekranda herhangi bir yere tıklayınca textFormField focusundan çıkmak için.
          FocusScope.of(context).unfocus();
        },
        child: GetBuilder<MenuViewModel>(
          init: MenuViewModel(),
          builder: (controller) {
            return Scaffold(
              body: Obx(
                () => IndexedStack(
                  index: controller.activeBottomBarIndex.value,
                  children: const [UserListView(), ToDoListView()],
                ),
              ),
              bottomNavigationBar: Obx(
                () => BottomNavigationBar(
                  currentIndex: controller.activeBottomBarIndex.value,
                  onTap: (value) {
                    ///Bottom navigation bardaki aktif sayfayı değiştirir.
                    controller.activeBottomBarIndex.value = value;
                  },
                  items: const [
                    BottomNavigationBarItem(
                      label: 'Üyeler',
                      icon: Icon(Icons.menu),
                    ),
                    BottomNavigationBarItem(
                      label: 'ToDo List',
                      icon: Icon(Icons.checklist),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
