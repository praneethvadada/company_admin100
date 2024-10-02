import 'package:flutter/material.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart'; // Import ProfilePage
import 'package:go_router/go_router.dart';
import 'core/utils/shared_preferences_util.dart';

void main() {
  runApp(AdminApp());
}

class AdminApp extends StatelessWidget {
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => HomePage()),
      GoRoute(
          path: '/profile',
          builder: (context, state) => ProfilePage()), // Add profile route
    ],
    redirect: (BuildContext context, GoRouterState state) async {
      final token = await SharedPreferencesUtil.getToken();
      print('Redirect Check - Token: $token');
      print('Current Route: ${state.uri.toString()}');

      if (token != null && state.uri.toString() == '/') {
        print('Redirecting to home page');
        return '/home';
      }

      if (token == null && state.uri.toString() == '/home') {
        print('Redirecting to login page');
        return '/';
      }

      return null;
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
          textTheme: TextTheme(
            labelMedium: TextStyle(fontSize: 20),
            titleMedium: TextStyle(fontSize: 20),
          ),
          cardTheme: CardTheme(color: Colors.white),
          primaryColor: Colors.red),
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
