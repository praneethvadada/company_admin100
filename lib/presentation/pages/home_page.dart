import 'package:company_admin100/presentation/pages/Tab%20Bar%20Screens/home_screen.dart';
import 'package:company_admin100/presentation/pages/Tab%20Bar%20Screens/manage_screen.dart';
import 'package:company_admin100/presentation/pages/Tab%20Bar%20Screens/assessents_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:company_admin100/core/utils/shared_preferences_util.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 3, vsync: this); // Now 3 tabs: Home, Manage, Assessments
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobileView = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image.network(
          'https://imgs.search.brave.com/YqsWcA-Tq0jMMCad5FV6KWALYUJPDEMGlpvMod9X3Qo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAxLzc1LzY3LzQz/LzM2MF9GXzE3NTY3/NDM2Ml9IUnYza3Nt/dThncTlqMmt0OGpB/U2RFOHR6OTI5UTdk/WC5qcGc', // Your logo path here
          height: 100,
          width: 100,
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(),
            if (isMobileView)
              SizedBox.shrink()
            else
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width *
                        0.7, // Scale text size relative to screen width
                    child: TabBar(
                      controller: _tabController,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        // fontSize: _getDynamicTextSize(MediaQuery.of(context)
                        //     .size
                        //     .width), // Adjust font size dynamically
                      ),
                      overlayColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide.none),
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.black,
                      dividerColor: Colors.transparent,
                      tabs: [
                        FittedBox(child: Tab(text: 'Home')),
                        FittedBox(child: Tab(text: 'Manage')),
                        FittedBox(child: Tab(text: 'Assessments')),
                      ],
                    ),
                  ),
                ),
              ),
            Spacer(),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'Profile') {
                  // Navigate to profile page
                  context.push('/profile');
                } else if (value == 'Logout') {
                  // Clear token and log out
                  await SharedPreferencesUtil.clearToken();
                  context.go('/');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                PopupMenuItem(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.grey,
                  size: 35,
                ),
              ),
            ),
          ],
        ),
        bottom: isMobileView
            ? TabBar(
                controller: _tabController,
                overlayColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                indicator:
                    const UnderlineTabIndicator(borderSide: BorderSide.none),
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: 'Home'),
                  Tab(text: 'Manage'),
                  Tab(text: 'Assessments'),
                ],
              )
            : null, // TabBar at the bottom for mobile view
      ),
      body: Column(
        children: [
          if (!isMobileView)
            Divider(
              color: Colors.grey,
              height: 1,
              thickness: 1,
            ), // Divider for desktop/tablet view
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                HomeScreen(), // Home tab content
                ManageScreen(), // Manage tab content
                AssessmentsScreen(), // Assessments tab content
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:company_admin100/presentation/pages/Tab%20Bar%20Screens/home_screen.dart';
// import 'package:company_admin100/presentation/pages/Tab%20Bar%20Screens/manage_screen.dart';
// import 'package:company_admin100/presentation/pages/Tab%20Bar%20Screens/assessents_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:company_admin100/core/utils/shared_preferences_util.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(
//         length: 3, vsync: this); // Now 3 tabs: Home, Manage, Assessments
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: Image.network(
//           'https://imgs.search.brave.com/YqsWcA-Tq0jMMCad5FV6KWALYUJPDEMGlpvMod9X3Qo/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAxLzc1LzY3LzQz/LzM2MF9GXzE3NTY3/NDM2Ml9IUnYza3Nt/dThncTlqMmt0OGpB/U2RFOHR6OTI5UTdk/WC5qcGc', // Your logo path here
//           height: 100,
//           width: 100,
//         ),
//         centerTitle: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Spacer(),
//             Expanded(
//               child: Center(
//                 child: Container(
//                   width: 370, // Adjust the width accordingly
//                   child: TabBar(
//                     overlayColor:
//                         WidgetStateProperty.all<Color>(Colors.transparent),
//                     // splashFactory: NoSplash.splashFactory,
//                     indicator: const UnderlineTabIndicator(
//                         borderSide: BorderSide.none),
//                     // overlayColor: Colors.transparent,
//                     unselectedLabelColor: Colors.grey,
//                     textScaler: TextScaler.linear(1),
//                     controller: _tabController,
//                     labelColor: Colors.black,
//                     // indicatorColor: Colors.blue,
//                     dividerColor: Colors.transparent,
//                     tabs: [
//                       Tab(text: 'Home'),
//                       Tab(text: 'Manage'),
//                       Tab(text: 'Assessments'),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Spacer(),
//             PopupMenuButton<String>(
//               onSelected: (value) async {
//                 if (value == 'Profile') {
//                   // Navigate to profile page
//                   context.push('/profile');
//                 } else if (value == 'Logout') {
//                   // Clear token and log out
//                   await SharedPreferencesUtil.clearToken();
//                   context.go('/');
//                 }
//               },
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: 'Profile',
//                   child: Text('Profile'),
//                 ),
//                 PopupMenuItem(
//                   value: 'Logout',
//                   child: Text('Logout'),
//                 ),
//               ],
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Icon(
//                   Icons.account_circle_outlined,
//                   color: Colors.grey,
//                   size: 35,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Divider(
//             color: Colors.grey,
//             height: 1,
//             thickness: 1,
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 HomeScreen(), // Home tab content
//                 ManageScreen(), // Manage tab content
//                 AssessmentsScreen(), // Assessments tab content
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
