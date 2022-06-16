import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/notifications_service.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_)=> AuthService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: 'login',
      routes: {
        'login'   : (context) => const LoginScreen(),
        'register': (context) => const RegisterScreen(),
        'check' : (context) => const CheckAuthScreen(),
        'home'    : (context) => const HomeScreen(),
        'product' : (context) => const ProductScreen(),

      },
      scaffoldMessengerKey: NotificationsService.messageKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.indigo
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        ),
      ),
    );
  }
}
