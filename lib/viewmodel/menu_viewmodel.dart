import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/state_manager.dart';

import '../core/api_routes.dart';
import '../core/http.dart';
import '../model/list_model.dart';
import '../model/todo_model.dart';

class MenuViewModel extends GetxController {
  var activeBottomBarIndex = 0.obs;

  ///MenuView'deki kullanıcıların listesi
  RxList userList = [].obs;

  ///ToDo'ların listesi
  RxList<ToDoModel> todoList = [ToDoModel()].obs;

  ///Highlighted ToDo'nun true diğerlerinin false olduğu liste
  RxList selectedIndex = [].obs;

  //ToDo için kullanılan TextFormField için Controller
  TextEditingController todosController = TextEditingController();

  ///ToDo boş veri kontrolü için formkey
  final formKey = GlobalKey<FormState>();

  ///ToDo TextFormField'ın focus Nodu
  FocusNode todoFocus = FocusNode();

  ///Seçilen ToDo'nun edit modunda olup olmadığının verisi
  RxBool isEditing = false.obs;

  ///
  Rx<ListUsersModel> listUsers = ListUsersModel().obs;

  var page = 1.obs;
  var totalPage = 1.obs;

  ///Kullanıcı listesini çekmek için API'ye istek atar.
  // [Refactoring, please wait...]
  getUserList() async {
    try {
      var response = await Http.get(
          '${APIRoutesEnum.listUsers.routeName}?page=${page.value}');

      ///statusCode 200 ise gelen veriyi [userList] değişkeni içerisine atar.
      if (response.statusCode == 200) {
        var decoded = jsonDecode(response.body);
        listUsers.value = ListUsersModel.fromJson(decoded);
        page.value = listUsers.value.page ?? 1;
        totalPage.value = listUsers.value.totalPages ?? 1;
        if (listUsers.value.data != null) {
          userList.clear();
          for (var element in listUsers.value.data!) {
            userList.add(element);
          }
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  pageUp() {
    if (page.value < totalPage.value) {
      page.value++;
      getUserList();
    }
  }

  pageDown() {
    if (page.value > 1) {
      page.value--;
      getUserList();
    }
  }

  ///Uygulama açılışında FSS'ten ToDo'ları çeker.
  getToDoList() async {
    var storage = const FlutterSecureStorage();
    todoList.clear();
    String? storedModelString = await storage.read(key: 'todolist');
    if (storedModelString != null) {
      var list = jsonDecode(storedModelString);
      for (var element in list) {
        todoList.add(ToDoModel.fromJson(element));
      }
      selectedIndex.clear();

      ///Highlighting için todoList boyutu kadar selectedIndex'i false ile doldurur.
      selectedIndex.addAll(List.filled(todoList.length, false));
    }
  }

  ///To Do List liste elemanına tıklayınca highlight olup
  ///daha önce highlighted olan elemanı normale çevirir.
  setUnhighlighted(context, c, index) {
    FocusScope.of(context).unfocus();
    if (index != -1) {
      if (!c.selectedIndex[index]) {
        for (var i = 0; i < c.selectedIndex.length; i++) {
          c.selectedIndex[i] = false;
        }
      }
      c.selectedIndex[index] = !c.selectedIndex[index];
    }
  }

  ///yazılmış ToDo'yu FSS'e kaydeder.
  saveToFSS(MenuViewModel c) async {
    var storage = const FlutterSecureStorage();
    String modelString = jsonEncode(c.todoList);

    await storage.write(key: 'todolist', value: modelString);
    if (c.todoList.isEmpty) {
      storage.delete(key: 'todoList');
    }
  }
}
