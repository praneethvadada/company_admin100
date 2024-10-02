import 'package:company_admin100/presentation/pages/Manage%20Screens/Colleges%20Panel/colleges_panel.dart';
import 'package:company_admin100/presentation/pages/Manage%20Screens/domains_panel.dart';
import 'package:company_admin100/presentation/pages/Manage%20Screens/questions_panel.dart';
import 'package:company_admin100/presentation/pages/Manage%20Screens/students_panel.dart';
import 'package:company_admin100/presentation/pages/Manage%20Screens/trainers_panel.dart';
import 'package:company_admin100/presentation/pages/Manage%20Screens/view_questions_panel.dart';
import 'package:flutter/material.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  // Track the selected menu item
  String selectedMenuItem = "Colleges";

  // Function to display content based on selected item
  Widget _buildRightPanel() {
    switch (selectedMenuItem) {
      case 'Colleges':
        return CollegesPanel(); // Ensure this widget is properly defined
      case 'Trainers':
        return TrainersPanel();
      case 'Students':
        return StudentsPanel();
      case 'Domains':
        return DomainsPanel();
      case 'Questions':
        return QuestionsPanel();
      case 'View Questions':
        return ViewQuestionsPanel();
      default:
        return CollegesPanel(); // Default to 'Colleges' panel
    }
  }

  // Sidebar items as a list
  List<Widget> _buildSidebarItems() {
    return [
      _buildSidebarItem(
          icon: Icons.school, text: 'Colleges', value: 'Colleges'),
      _buildSidebarItem(
          icon: Icons.person, text: 'Trainers', value: 'Trainers'),
      _buildSidebarItem(icon: Icons.group, text: 'Students', value: 'Students'),
      _buildSidebarItem(icon: Icons.domain, text: 'Domains', value: 'Domains'),
      _buildSidebarItem(
          icon: Icons.question_answer, text: 'Questions', value: 'Questions'),
      _buildSidebarItem(
          icon: Icons.view_list,
          text: 'View Questions',
          value: 'View Questions'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Detect screen width
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              // Show AppBar only for mobile view
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context)
                          .openDrawer(); // Open the drawer in mobile view
                    },
                  );
                },
              ),
            )
          : null, // No AppBar for larger screens
      drawer: isMobile ? _buildDrawer() : null, // Show drawer only on mobile
      body: Row(
        children: [
          // Sidebar for larger screens
          if (!isMobile)
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: SingleChildScrollView(
                child: Column(
                  children: _buildSidebarItems(),
                ),
              ),
            ),
          // Right content area
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 0, left: 16, top: 16, bottom: 16),
              child: _buildRightPanel(),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // Detect screen width
  //   bool isMobile = MediaQuery.of(context).size.width < 600;

  //   return Scaffold(
  //     appBar: AppBar(
  //       // title: Text('Manage Screen'),
  //       // Use Builder to access the correct Scaffold context
  //       leading: isMobile
  //           ? Builder(
  //               builder: (BuildContext context) {
  //                 return IconButton(
  //                   icon: Icon(Icons.menu),
  //                   onPressed: () {
  //                     Scaffold.of(context)
  //                         .openDrawer(); // Open the drawer in mobile view
  //                   },
  //                 );
  //               },
  //             )
  //           : null, // No menu button for larger screens
  //     ),
  //     drawer: isMobile ? _buildDrawer() : null, // Show drawer only on mobile
  //     body: Row(
  //       children: [
  //         // Sidebar for larger screens
  //         if (!isMobile)
  //           Container(
  //             width: MediaQuery.of(context).size.width * 0.15,
  //             child: SingleChildScrollView(
  //               child: Column(
  //                 children: _buildSidebarItems(),
  //               ),
  //             ),
  //           ),
  //         // Right content area
  //         Expanded(
  //           child: Container(
  //             padding: EdgeInsets.only(right: 0, left: 16, top: 16, bottom: 16),
  //             child: _buildRightPanel(),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Drawer widget for mobile view
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // DrawerHeader(
          //   child: Text('Manage'),
          //   decoration: BoxDecoration(),
          // ),
          ..._buildSidebarItems(),
        ],
      ),
    );
  }

  // Helper function to build sidebar item
  Widget _buildSidebarItem(
      {required IconData icon, required String text, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15),
      child: ListTile(
        title: Column(
          children: [
            Icon(icon),
            SizedBox(height: 3),
            Text(text),
          ],
        ),
        onTap: () {
          setState(() {
            selectedMenuItem = value;
          });
          if (MediaQuery.of(context).size.width < 600) {
            Navigator.pop(
                context); // Close the drawer after selection on mobile
          }
        },
        iconColor: Colors.black,
        selected: selectedMenuItem == value,
      ),
    );
  }
}

// import 'package:company_admin100/presentation/pages/Manage%20Screens/Colleges%20Panel/colleges_panel.dart';
// import 'package:company_admin100/presentation/pages/Manage%20Screens/domains_panel.dart';
// import 'package:company_admin100/presentation/pages/Manage%20Screens/questions_panel.dart';
// import 'package:company_admin100/presentation/pages/Manage%20Screens/students_panel.dart';
// import 'package:company_admin100/presentation/pages/Manage%20Screens/trainers_panel.dart';
// import 'package:company_admin100/presentation/pages/Manage%20Screens/view_questions_panel.dart';
// import 'package:flutter/material.dart';

// class ManageScreen extends StatefulWidget {
//   @override
//   _ManageScreenState createState() => _ManageScreenState();
// }

// class _ManageScreenState extends State<ManageScreen> {
//   // Track the selected menu item
//   String selectedMenuItem = "Colleges";

//   // Function to display content based on selected item
//   Widget _buildRightPanel() {
//     switch (selectedMenuItem) {
//       case 'Colleges':
//         return CollegesPanel(); // Ensure this widget is properly defined
//       case 'Trainers':
//         return TrainersPanel();
//       case 'Students':
//         return StudentsPanel();
//       case 'Domains':
//         return DomainsPanel();
//       case 'Questions':
//         return QuestionsPanel();
//       case 'View Questions':
//         return ViewQuestionsPanel();
//       default:
//         return CollegesPanel(); // Default to 'Colleges' panel
//     }
//   }

//   // Sidebar items as a list
//   List<Widget> _buildSidebarItems() {
//     return [
//       _buildSidebarItem(
//           icon: Icons.school, text: 'Colleges', value: 'Colleges'),
//       _buildSidebarItem(
//           icon: Icons.person, text: 'Trainers', value: 'Trainers'),
//       _buildSidebarItem(icon: Icons.group, text: 'Students', value: 'Students'),
//       _buildSidebarItem(icon: Icons.domain, text: 'Domains', value: 'Domains'),
//       _buildSidebarItem(
//           icon: Icons.question_answer, text: 'Questions', value: 'Questions'),
//       _buildSidebarItem(
//           icon: Icons.view_list,
//           text: 'View Questions',
//           value: 'View Questions'),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Detect screen width
//     bool isMobile = MediaQuery.of(context).size.width < 600;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Screen'),
//         leading: isMobile
//             ? IconButton(
//                 icon: Icon(Icons.menu),
//                 onPressed: () {
//                   Scaffold.of(context)
//                       .openDrawer(); // Open the drawer in mobile view
//                 },
//               )
//             : null, // No menu button for larger screens
//       ),
//       drawer: isMobile ? _buildDrawer() : null, // Show drawer only on mobile
//       body: Row(
//         children: [
//           // Sidebar for larger screens
//           if (!isMobile)
//             Container(
//               width: MediaQuery.of(context).size.width * 0.15,
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: _buildSidebarItems(),
//                 ),
//               ),
//             ),
//           // Right content area
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.only(right: 0, left: 16, top: 16, bottom: 16),
//               child: _buildRightPanel(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Drawer widget for mobile view
//   Widget _buildDrawer() {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             child: Text('Navigation'),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//           ),
//           ..._buildSidebarItems(),
//         ],
//       ),
//     );
//   }

//   // Helper function to build sidebar item
//   Widget _buildSidebarItem(
//       {required IconData icon, required String text, required String value}) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 15.0, bottom: 15),
//       child: ListTile(
//         title: Column(
//           children: [
//             Icon(icon),
//             SizedBox(height: 3),
//             Text(text),
//           ],
//         ),
//         onTap: () {
//           setState(() {
//             selectedMenuItem = value;
//           });
//           if (MediaQuery.of(context).size.width < 600) {
//             Navigator.pop(
//                 context); // Close the drawer after selection on mobile
//           }
//         },
//         iconColor: Colors.black,
//         selected: selectedMenuItem == value,
//       ),
//     );
//   }
// }


// // import 'package:company_admin100/presentation/pages/Manage%20Screens/Colleges%20Panel/colleges_panel.dart';
// // import 'package:company_admin100/presentation/pages/Manage%20Screens/domains_panel.dart';
// // import 'package:company_admin100/presentation/pages/Manage%20Screens/questions_panel.dart';
// // import 'package:company_admin100/presentation/pages/Manage%20Screens/students_panel.dart';
// // import 'package:company_admin100/presentation/pages/Manage%20Screens/trainers_panel.dart';
// // import 'package:company_admin100/presentation/pages/Manage%20Screens/view_questions_panel.dart';
// // import 'package:flutter/material.dart';

// // class ManageScreen extends StatefulWidget {
// //   @override
// //   _ManageScreenState createState() => _ManageScreenState();
// // }

// // class _ManageScreenState extends State<ManageScreen> {
// //   // Track the selected menu item
// //   String selectedMenuItem = "Colleges";

// //   // Function to display content based on selected item
// //   Widget _buildRightPanel() {
// //     switch (selectedMenuItem) {
// //       case 'Colleges':
// //         return CollegesPanel(); // Ensure this widget is properly defined
// //       case 'Trainers':
// //         return TrainersPanel();
// //       case 'Students':
// //         return StudentsPanel();
// //       case 'Domains':
// //         return DomainsPanel();
// //       case 'Questions':
// //         return QuestionsPanel();
// //       case 'View Questions':
// //         return ViewQuestionsPanel();
// //       default:
// //         return CollegesPanel(); // Default to 'Colleges' panel
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Row(
// //         children: [
// //           // Sidebar
// //           Container(
// //             width: MediaQuery.of(context).size.width * 0.15,
// //             // color: Colors.grey[200], // Optional: Set background color for sidebar
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 children: [
// //                   _buildSidebarItem(
// //                       icon: Icons.school, text: 'Colleges', value: 'Colleges'),
// //                   _buildSidebarItem(
// //                       icon: Icons.person, text: 'Trainers', value: 'Trainers'),
// //                   _buildSidebarItem(
// //                       icon: Icons.group, text: 'Students', value: 'Students'),
// //                   _buildSidebarItem(
// //                       icon: Icons.domain, text: 'Domains', value: 'Domains'),
// //                   _buildSidebarItem(
// //                       icon: Icons.question_answer,
// //                       text: 'Questions',
// //                       value: 'Questions'),
// //                   _buildSidebarItem(
// //                       icon: Icons.view_list,
// //                       text: 'View Questions',
// //                       value: 'View Questions'),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           // Right content area changes based on the sidebar selection
// //           Expanded(
// //             child: Container(
// //               padding: EdgeInsets.only(right: 0, left: 16, top: 16, bottom: 16),
// //               child: _buildRightPanel(),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Helper function to build sidebar item
// //   Widget _buildSidebarItem(
// //       {required IconData icon, required String text, required String value}) {
// //     return Padding(
// //       padding: const EdgeInsets.only(top: 15.0, bottom: 15),
// //       child: ListTile(
// //         // leading: Icon(icon),
// //         title: Column(
// //           children: [
// //             Icon(icon),
// //             SizedBox(
// //               height: 3,
// //             ),
// //             Text(text),
// //           ],
// //         ),
// //         onTap: () {
// //           setState(() {
// //             selectedMenuItem = value;
// //           });
// //         },
// //         iconColor: Colors.black,
        
// //         selected: selectedMenuItem == value,
// //         // selectedTileColor: Colors.grey[300], // Optional: Highlight selected tile
// //       ),
// //     );
// //   }
// // }
