import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/products_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Checkout App',
      theme: ThemeData(useMaterial3: false, primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/products': (_) => const ProductsScreen(),
        '/cart': (_) => const CartScreen(),
        '/payment': (_) => const PaymentScreen(),
      },
    );
  }
}
