import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../core/api_routes.dart';
import '../core/http.dart';
import '../viewmodel/menu_viewmodel.dart';

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuViewModel>(
        init: MenuViewModel(),
        initState: (state) async {
          //Sayfa ilk yüklenişinde kullanıcı listesini apiden çeker.
          await Get.find<MenuViewModel>().getUserList();
        },
        builder: (c) {
          return Scaffold(
            appBar: AppBar(
                title: const Text('Kullanıcılar'),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    //Beni hatırla ve token'ı FSS'ten silip çıkış yapar.
                    var storage = const FlutterSecureStorage();
                    storage.write(key: 'token', value: '');
                    storage.write(key: 'rememberMe', value: 'false');
                    Http.post(
                        requestLink: APIRoutesEnum.logout.routeName,
                        data: null);
                    Get.offAllNamed('/login');
                  },
                )),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                    child: Obx(() => c.userList.isEmpty
                        ? const Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Yükleniyor'),
                              SizedBox(height: 10),
                              CircularProgressIndicator(),
                            ],
                          ))
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: ListView.builder(
                              itemCount: c.userList.length,
                              itemExtent: 80,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 20,
                                  child: Center(
                                    child: ListTile(
                                      leading: Image.network(
                                        c.userList[index].avatar!,
                                        cacheHeight: 600,
                                        cacheWidth: 600,
                                        fit: BoxFit.fill,
                                      ),
                                      title: Text(
                                          '${c.userList[index].firstName!} ${c.userList[index].lastName!}'),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                  ),
                  Flexible(
                    flex: 1,
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        c.page.value == 1 ? Colors.grey : null),
                                onPressed: () {
                                  c.pageDown();
                                },
                                child: const Text('Geri')),
                            Text('${c.page}'),
                            const Text('/'),
                            Text('${c.totalPage}'),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        c.page.value == c.totalPage.value
                                            ? Colors.grey
                                            : null),
                                onPressed: () {
                                  c.pageUp();
                                },
                                child: const Text('İleri')),
                          ],
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }
}
