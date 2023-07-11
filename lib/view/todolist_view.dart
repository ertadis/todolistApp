// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/todo_model.dart';
import '../viewmodel/menu_viewmodel.dart';

class ToDoListView extends StatelessWidget {
  const ToDoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuViewModel>(
        init: MenuViewModel(),
        initState: (state) async {
          //Sayfa ilk yüklenişinde FSS'ten ToDo'ları çeker.
          Get.find<MenuViewModel>().getToDoList();
        },
        builder: (c) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => (c.todoList.isEmpty || c.selectedIndex.isEmpty)
                      ? const SizedBox.shrink()
                      : Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: ListView.builder(
                              itemCount: c.todoList.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 20,
                                  child: StatefulBuilder(
                                      builder: (context, setState) {
                                    return Obx(() => ListTile(
                                          tileColor: (c.selectedIndex[index] &&
                                                  c.isEditing.value)
                                              ? Colors.amber
                                              : c.selectedIndex[index]
                                                  ? Colors.yellow.shade100
                                                  : (index % 2 == 0)
                                                      ? Colors.grey.shade500
                                                      : Colors.grey.shade300,
                                          onTap: () {
                                            if (c.isEditing.value) {
                                              //Edit modunda ToDo'lara tıklayınca edit modundan çıkarır.
                                              c.isEditing.value = false;
                                              c.todosController.text = '';
                                            }
                                            c.setUnhighlighted(
                                                context, c, index);
                                          },
                                          leading: Text('${index + 1}. '),
                                          title: Text(
                                            c.todoList[index].task!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              decoration: c.todoList[index]
                                                      .completed!
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                            ),
                                          ),
                                          trailing: c.selectedIndex[index]
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            //Tamamlanmış ToDo'ların üstünü çizer.
                                                            setState(() {
                                                              c.todoList[index]
                                                                      .completed =
                                                                  !c
                                                                      .todoList[
                                                                          index]
                                                                      .completed!;
                                                            });
                                                            c.saveToFSS(c);
                                                          },
                                                          icon: const Icon(
                                                              Icons.check)),
                                                      IconButton(
                                                          onPressed: () {
                                                            //ToDo'ları editleme modunu aktifleştirir.
                                                            c.isEditing.value =
                                                                true;
                                                            c.todosController
                                                                    .text =
                                                                c
                                                                    .todoList[
                                                                        index]
                                                                    .task!;
                                                            c.todoFocus
                                                                .requestFocus();
                                                          },
                                                          icon: const Icon(
                                                              Icons.edit)),
                                                      IconButton(
                                                          onPressed: () {
                                                            //ToDo'ları siler.
                                                            c.todoList.removeAt(
                                                                index);
                                                            c.selectedIndex
                                                                .removeAt(
                                                                    index);
                                                            c.saveToFSS(c);
                                                          },
                                                          icon: const Icon(
                                                              Icons.delete))
                                                    ])
                                              : null,
                                        ));
                                  }),
                                );
                              },
                            ),
                          )),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 10),
                    child: Obx(
                      () => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 20,
                        color: c.isEditing.value
                            ? Colors.amber
                            : Colors.yellow.shade100,
                        child: Form(
                          key: c.formKey,
                          child: TextFormField(
                            focusNode: c.todoFocus,
                            controller: c.todosController,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == '') {
                                return 'Kaydetmek için bu alanı boş bırakmayın.';
                              } else if (value != null && value.contains('`')) {
                                return '` karakterini kullanamazsınız';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                suffix: IconButton(
                                  icon: const Icon(Icons.save),
                                  onPressed: () async {
                                    c.formKey.currentState?.validate();
                                    //ToDo'ya sadece boşluk kullanılıp kullanılmadığını kontrol eder.
                                    if (c.todosController.text
                                            .removeAllWhitespace !=
                                        '') {
                                      if (c.isEditing.value) {
                                        //Edit modu aktifse değiştirilecek ToDo'yu değiştirir.
                                        c
                                            .todoList[c.selectedIndex
                                                .indexWhere((p0) => p0 == true)]
                                            .task = c.todosController.text;
                                        c.isEditing.value = false;
                                      } else {
                                        //yazılmış ToDo'yu edit değilse listeye kaydeder.
                                        c.todoList.add(
                                          ToDoModel(
                                              uuid: const Uuid().v4(),
                                              task: c.todosController.text,
                                              completed: false),
                                        );
                                        c.selectedIndex.add(false);
                                      }
                                      c.saveToFSS(c);
                                      //Kayıttan sonra controller'i temizler.
                                      c.todosController.text = '';
                                      c.setUnhighlighted(
                                          context,
                                          c,
                                          c.selectedIndex
                                              .indexWhere((p0) => p0 == true));
                                    }
                                  },
                                ),
                                labelText: 'To Do?',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            minLines: 1,
                            maxLines: 2,
                          ),
                        ),
                      ),
                    ))
              ],
            ),
          );
        });
  }
}
