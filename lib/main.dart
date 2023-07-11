import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:todolistapp/view/login_view.dart';
import 'package:todolistapp/view/menu_view.dart';

var initialRoute = '/login';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var storage = const FlutterSecureStorage();
  var rememberMe = await storage.read(key: 'rememberMe');
  var token = await storage.read(key: 'token');
  //Beni hatırla etkin ve FSS'te token varsa MenuView'a yönlendirir.
  if (rememberMe == 'true' && token != '') {
    initialRoute = '/home';
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginView(),
        '/home': (context) => const MenuView()
      },
    );
  }
}
