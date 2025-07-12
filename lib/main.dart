// import 'package:flutter/material.dart';
// import 'package:laptop_harbor/route/route_constants.dart';
// import 'package:laptop_harbor/route/router.dart' as router;
// import 'package:laptop_harbor/screens/product/views/components/products_details_screen.dart';
// import 'package:laptop_harbor/theme/app_theme.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Laptop Harbor',
//       theme: AppTheme.lightTheme(context),
//       themeMode: ThemeMode.light,
//       onGenerateRoute: router.generateRoute,
//       initialRoute: onbordingScreenRoute,
//         routes: {
//           productDetailsScreenRoute: (context) => const ProductDetailsScreen(),
//         }
//
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:laptop_harbor/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'package:laptop_harbor/theme/app_theme.dart';
import 'package:laptop_harbor/route/route_constants.dart';
import 'package:laptop_harbor/route/router.dart' as router;

import 'package:laptop_harbor/providers/cart_provider.dart';
import 'package:laptop_harbor/screens/cart/views/cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()), // ✅ Add this line
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Laptop Harbor',
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        onGenerateRoute: router.generateRoute,
        initialRoute: onbordingScreenRoute,

      ),
    );
  }
}
