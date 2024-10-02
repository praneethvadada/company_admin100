import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:company_admin100/core/utils/shared_preferences_util.dart';

class ProfilePage extends StatelessWidget {
  final String adminName =
      "Admin"; // Example admin name, replace with real data
  final String email =
      "admin@company.com"; // Example email, replace with real data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage('https://profile-url.png'), // Profile image URL
            ),
            SizedBox(height: 16),
            Text(
              'Name: $adminName',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await SharedPreferencesUtil.clearToken();
                context.go('/'); // Navigate back to login page
              },
              child: Text('Logout'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:company_admin100/core/utils/shared_preferences_util.dart';

// class ProfilePage extends StatelessWidget {
//   final String adminName =
//       "Admin"; // Example admin name, replace with real data
//   final String email =
//       "admin@company.com"; // Example email, replace with real data

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage:
//                   NetworkImage('https://profile-url.png'), // Profile image URL
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Name: $adminName',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Email: $email',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 await SharedPreferencesUtil.clearToken();
//                 context.go('/'); // Navigate back to login page
//               },
//               child: Text('Logout'),
//               style:
//                   ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
