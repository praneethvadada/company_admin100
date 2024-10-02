import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> questions = []; // List to store questions
  bool isLoading = true;
  bool noQuestions = false;
  bool showRejected = false; // Toggle for showing rejected questions

  @override
  void initState() {
    super.initState();
    fetchQuestions(); // Fetch pending questions by default
  }

  // Function to show the dialog with complete question details
  void _showQuestionDetailsDialog(
      BuildContext context, Map<String, dynamic> question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(question['title']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text(question['description']),
                SizedBox(height: 20),
                Text("Test Cases:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...question['testcases'].map<Widget>((testcase) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Input: ${testcase['input']}"),
                      Text("Expected Output: ${testcase['expected_output']}"),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                updateQuestionStatus(question['id'], 'approved');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Approve'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updateQuestionStatus(question['id'], 'rejected');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Reject'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without any action
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Function to fetch questions (pending or rejected)
  Future<void> fetchQuestions() async {
    setState(() {
      isLoading = true;
      noQuestions = false;
    });

    String status = showRejected ? 'rejected' : 'pending';
    final response = await http.get(
        Uri.parse('http://localhost:3000/questions/getAll?status=$status'));

    if (response.statusCode == 200) {
      setState(() {
        questions = json.decode(response.body);
        isLoading = false;
        if (questions.isEmpty) {
          noQuestions = true; // Set to true if no questions
        }
      });
    } else {
      throw Exception('Failed to load questions');
    }
  }

  // Function to approve or reject a question
  Future<void> updateQuestionStatus(int questionId, String status) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/questions/update/$questionId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'approval_status': status,
      }),
    );

    if (response.statusCode == 200) {
      print('Question $questionId updated to $status');
      fetchQuestions(); // Refresh the questions list
    } else {
      throw Exception('Failed to update question');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          // Three Boxes Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBox(context, 'No of Students', 'View Insights', '+200k'),
              _buildBox(context, 'Assessments', 'Open Assessments', '+330'),
              _buildBox(context, 'Insights', 'View Insights', '\$479.8'),
            ],
          ),
          SizedBox(height: 20),
          // Questions for Approval Section with Refresh Button
          Container(
            color: const Color.fromARGB(255, 246, 242, 246),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Text(
                    showRejected
                        ? 'Rejected Questions'
                        : 'Questions for Approval',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Row(
                    children: [
                      // Button to toggle between Pending and Rejected questions
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showRejected = !showRejected;
                          });
                          fetchQuestions(); // Fetch corresponding questions
                        },
                        child: Row(
                          children: [
                            Icon(
                              showRejected ? Icons.check_box : Icons.error,
                              color: showRejected ? Colors.green : Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(showRejected
                                ? "Show Pending"
                                : "Show Rejected"),
                          ],
                        ),
                      ),
                      // Refresh button
                      // TextButton(
                      //   onPressed: fetchQuestions, // Refresh the questions list
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.refresh, color: Colors.blue),
                      //       SizedBox(width: 5),
                      //       // Text("Refresh"),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : noQuestions
                  ? _buildNoQuestionsWidget() // Display this widget when no questions are available
                  : _buildQuestionList(), // Show question list when questions are available
        ],
      ),
    );
  }

  // Function to build the three boxes
  Widget _buildBox(
      BuildContext context, String title, String value, String change) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 249, 229, 236).withOpacity(0.3),
              Colors.white.withOpacity(0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.9],
          ),
          border: Border.all(width: 0.08, color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width < 600
                        ? 12
                        : 15, // Smaller font size for mobile
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 600
                        ? 20
                        : 24, // Smaller font size for mobile
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width < 600
                        ? 14
                        : 16, // Smaller font size for mobile
                    color: change.contains('-') ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          // child: Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 10.0),
          //       child: Text(
          //         title,
          //         style: TextStyle(
          //             color: Colors.grey,
          //             fontSize: 15,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     SizedBox(height: 10),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 10.0),
          //       child: Text(
          //         value,
          //         style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     SizedBox(height: 5),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 10.0),
          //       child: Text(
          //         change,
          //         style: TextStyle(
          //           fontSize: 16,
          //           color: change.contains('-') ? Colors.red : Colors.green,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  // Function to build the question list
  Widget _buildQuestionList() {
    return Column(
      children: questions.map((question) {
        return Column(
          children: [
            GestureDetector(
              onTap: () => _showQuestionDetailsDialog(
                  context, question), // Show details when tapped
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Text(
                                question['description'],
                                style: TextStyle(color: Colors.black87),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          children: [
                            Text(
                              'Question by:',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Trainer ID: ${question['added_by']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            children: [
                              // Approve button on main page (Only for pending questions)
                              if (!showRejected) ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: const Color.fromARGB(
                                        255, 228, 243, 229),
                                  ),
                                  onPressed: () {
                                    updateQuestionStatus(
                                        question['id'], 'approved');
                                  },
                                  child: Text(
                                    'Approve',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Reject button on main page (Only for pending questions)
                                ElevatedButton(
                                  onPressed: () {
                                    updateQuestionStatus(
                                        question['id'], 'rejected');
                                  },
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    backgroundColor: const Color.fromARGB(
                                        255, 242, 217, 215),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
          ],
        );
      }).toList(),
    );
  }

  // Widget to display when there are no questions pending approval
  Widget _buildNoQuestionsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            // width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.13,
          ),
          Text(
            !showRejected ? 'No Pending Questions' : 'No Rejected Questions',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: fetchQuestions, // Allow the user to refresh
            child: Text("Refresh"),
          ),
          SizedBox(height: 10),
          // Container(
          // width: MediaQuery.of(context).size.width * 0.3,
          // height: MediaQuery.of(context).size.height * 0.3,
          //   child: Image.asset(
          //     width: MediaQuery.of(context).size.width * 0.15,
          //     height: MediaQuery.of(context).size.height * 0.5,
          //     // width: 250,
          //     // height: 350,
          //     fit: BoxFit.contain,
          //     'assets/no_questions2.png',
          //   ),
          // ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'dart:convert'; // For JSON encoding/decoding
// import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> questions = []; // List to store pending questions
//   bool isLoading = true;
//   bool noQuestions = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchPendingQuestions();
//   }

//   // Function to show the dialog with complete question details
//   void _showQuestionDetailsDialog(
//       BuildContext context, Map<String, dynamic> question) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(question['title']),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("Description:",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(height: 5),
//                 Text(question['description']),
//                 SizedBox(height: 20),
//                 Text("Test Cases:",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 ...question['testcases'].map<Widget>((testcase) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Input: ${testcase['input']}"),
//                       Text("Expected Output: ${testcase['expected_output']}"),
//                       SizedBox(height: 10),
//                     ],
//                   );
//                 }).toList(),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 updateQuestionStatus(question['id'], 'approved');
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Approve'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 updateQuestionStatus(question['id'], 'rejected');
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Reject'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context)
//                     .pop(); // Close the dialog without any action
//               },
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to fetch pending questions
//   Future<void> fetchPendingQuestions() async {
//     setState(() {
//       isLoading = true;
//       noQuestions = false;
//     });
//     final response = await http.get(
//         Uri.parse('http://localhost:3000/questions/getAll?status=pending'));

//     if (response.statusCode == 200) {
//       setState(() {
//         questions = json.decode(response.body);
//         isLoading = false;
//         if (questions.isEmpty) {
//           noQuestions = true; // Set to true if no pending questions
//         }
//       });
//     } else {
//       throw Exception('Failed to load questions');
//     }
//   }

//   // Function to approve or reject a question
//   Future<void> updateQuestionStatus(int questionId, String status) async {
//     final response = await http.put(
//       Uri.parse('http://localhost:3000/questions/update/$questionId'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'approval_status': status,
//       }),
//     );

//     if (response.statusCode == 200) {
//       print('Question $questionId updated to $status');
//       fetchPendingQuestions(); // Refresh the questions list
//     } else {
//       throw Exception('Failed to update question');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 15),
//           // Three Boxes Section
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildBox(context, 'Insights', 'View Insights', '+4.75%'),
//               _buildBox(context, 'Overdue invoices', '\$12,787.00', '+54.02%'),
//               _buildBox(context, 'Expenses', '\$30,156.00', '+10.18%'),
//             ],
//           ),
//           SizedBox(height: 20),
//           // Questions for Approval Section with Refresh Button
//           Container(
//             color: const Color.fromARGB(255, 246, 242, 246),
//             height: 50,
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15.0),
//                   child: Text(
//                     'Questions for Approval',
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Spacer(),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 15.0),
//                   child: TextButton(
//                     onPressed:
//                         fetchPendingQuestions, // Refresh the questions list
//                     child: Row(
//                       children: [
//                         Icon(Icons.refresh, color: Colors.blue),
//                         SizedBox(width: 5),
//                         Text("Refresh"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           isLoading
//               ? Center(child: CircularProgressIndicator())
//               : noQuestions
//                   ? _buildNoQuestionsWidget() // Display this widget when no questions are available
//                   : _buildQuestionList(), // Show question list when questions are available
//         ],
//       ),
//     );
//   }

//   // Function to build the three boxes
//   Widget _buildBox(
//       BuildContext context, String title, String value, String change) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               const Color.fromARGB(255, 249, 229, 236).withOpacity(0.3),
//               Colors.white.withOpacity(0.5),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             stops: const [0.1, 0.9],
//           ),
//           border: Border.all(width: 0.08, color: Colors.grey),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//               Text(
//                 value,
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 5),
//               Text(
//                 change,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: change.contains('-') ? Colors.red : Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Function to build the question list
//   Widget _buildQuestionList() {
//     return Column(
//       children: questions.map((question) {
//         return Column(
//           children: [
//             GestureDetector(
//               onTap: () => _showQuestionDetailsDialog(
//                   context, question), // Show details when tapped
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 25.0),
//                 child: Container(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   child: Padding(
//                     padding: const EdgeInsets.all(1.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 question['title'],
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               SizedBox(height: 5),
//                               Text(
//                                 question['description'],
//                                 style: TextStyle(color: Colors.black87),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: 5),
//                         Column(
//                           children: [
//                             Text(
//                               'Question by:',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                             Text(
//                               'Trainer ID: ${question['added_by']}',
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(18.0),
//                           child: Row(
//                             children: [
//                               // Approve button on main page
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 228, 243, 229),
//                                 ),
//                                 onPressed: () {
//                                   updateQuestionStatus(
//                                       question['id'], 'approved');
//                                 },
//                                 child: Text(
//                                   'Approve',
//                                   style: TextStyle(color: Colors.green),
//                                 ),
//                               ),
//                               SizedBox(width: 10),
//                               // Reject button on main page
//                               ElevatedButton(
//                                 onPressed: () {
//                                   updateQuestionStatus(
//                                       question['id'], 'rejected');
//                                 },
//                                 child: Text(
//                                   'Reject',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 242, 217, 215),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Divider(),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   // Widget to display when there are no questions pending approval
//   Widget _buildNoQuestionsWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(height: 20),
//           Text(
//             'No Pending Questions',
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black54),
//           ),
//           SizedBox(height: 10),
//           ElevatedButton(
//             onPressed: fetchPendingQuestions, // Allow the user to refresh
//             child: Text("Refresh"),
//           ),
//           SizedBox(height: 10),
//           Container(
//             // width: MediaQuery.of(context).size.width * 0.2,
//             // height: MediaQuery.of(context).size.height * 0.2,
//             child: Image.asset(
//               fit: BoxFit.fitWidth,
//               'assets/no_questions.png',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// // import 'package:flutter/material.dart';
// // import 'dart:convert'; // For JSON encoding/decoding
// // import 'package:http/http.dart' as http;

// // class HomeScreen extends StatefulWidget {
// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   List<dynamic> questions = []; // List to store pending questions
// //   bool isLoading = true;
// //   bool noQuestions = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchPendingQuestions();
// //   }

// //    void _showQuestionDetailsDialog(BuildContext context, Map<String, dynamic> question) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(question['title']),
// //           content: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
// //                 SizedBox(height: 5),
// //                 Text(question['description']),
// //                 SizedBox(height: 20),
// //                 Text("Test Cases:", style: TextStyle(fontWeight: FontWeight.bold)),
// //                 ...question['testcases'].map<Widget>((testcase) {
// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text("Input: ${testcase['input']}"),
// //                       Text("Expected Output: ${testcase['expected_output']}"),
// //                       SizedBox(height: 10),
// //                     ],
// //                   );
// //                 }).toList(),
// //               ],
// //             ),
// //           ),
// //           actions: [
// //             ElevatedButton(
// //               onPressed: () {
// //                 updateQuestionStatus(question['id'], 'approved');
// //                 Navigator.of(context).pop(); // Close the dialog
// //               },
// //               child: Text('Approve'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.green,
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 updateQuestionStatus(question['id'], 'rejected');
// //                 Navigator.of(context).pop(); // Close the dialog
// //               },
// //               child: Text('Reject'),
// //               style: ElevatedButton.styleFrom(
// //                 backgroundColor: Colors.red,
// //               ),
// //             ),
// //             ElevatedButton(
// //               onPressed: () {
// //                 Navigator.of(context).pop(); // Close the dialog without any action
// //               },
// //               child: Text('Close'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // Function to fetch pending questions
// //   Future<void> fetchPendingQuestions() async {
// //     setState(() {
// //       isLoading = true;
// //       noQuestions = false;
// //     });
// //     final response = await http.get(
// //         Uri.parse('http://localhost:3000/questions/getAll?status=pending'));

// //     if (response.statusCode == 200) {
// //       setState(() {
// //         questions = json.decode(response.body);
// //         isLoading = false;
// //         if (questions.isEmpty) {
// //           noQuestions = true; // Set to true if no pending questions
// //         }
// //       });
// //     } else {
// //       throw Exception('Failed to load questions');
// //     }
// //   }

// //   // Function to approve or reject a question
// //   Future<void> updateQuestionStatus(int questionId, String status) async {
// //     final response = await http.put(
// //       Uri.parse('http://localhost:3000/questions/update/$questionId'),
// //       headers: <String, String>{
// //         'Content-Type': 'application/json; charset=UTF-8',
// //       },
// //       body: jsonEncode(<String, String>{
// //         'approval_status': status,
// //       }),
// //     );

// //     if (response.statusCode == 200) {
// //       print('Question $questionId updated to $status');
// //       fetchPendingQuestions(); // Refresh the questions list
// //     } else {
// //       throw Exception('Failed to update question');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           SizedBox(height: 15),
// //           // Three Boxes Section
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               _buildBox(context, 'Insights', 'View Insights', '+4.75%'),
// //               _buildBox(context, 'Overdue invoices', '\$12,787.00', '+54.02%'),
// //               _buildBox(context, 'Expenses', '\$30,156.00', '+10.18%'),
// //             ],
// //           ),
// //           SizedBox(height: 20),
// //           // Questions for Approval Section with Refresh Button
// //           Container(
// //             color: const Color.fromARGB(255, 246, 242, 246),
// //             height: 50,
// //             width: MediaQuery.of(context).size.width,
// //             child: Row(
// //               children: [
// //                 Padding(
// //                   padding: const EdgeInsets.only(left: 15.0),
// //                   child: Text(
// //                     'Questions for Approval',
// //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
// //                   ),
// //                 ),
// //                 Spacer(),
// //                 Padding(
// //                   padding: const EdgeInsets.only(right: 15.0),
// //                   child: TextButton(
// //                     onPressed:
// //                         fetchPendingQuestions, // Refresh the questions list
// //                     child: Row(
// //                       children: [
// //                         Icon(Icons.refresh, color: Colors.blue),
// //                         SizedBox(width: 5),
// //                         Text("Refresh"),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: 10),
// //           isLoading
// //               ? Center(child: CircularProgressIndicator())
// //               : noQuestions
// //                   ? _buildNoQuestionsWidget() // Display this widget when no questions are available
// //                   : _buildQuestionList(), // Show question list when questions are available
// //         ],
// //       ),
// //     );
// //   }

// //   // Function to build the three boxes
// //   Widget _buildBox(
// //       BuildContext context, String title, String value, String change) {
// //     return Expanded(
// //       child: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [
// //               const Color.fromARGB(255, 249, 229, 236).withOpacity(0.3),
// //               Colors.white.withOpacity(0.5),
// //             ],
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             stops: const [0.1, 0.9],
// //           ),
// //           border: Border.all(width: 0.08, color: Colors.grey),
// //         ),
// //         child: Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Text(
// //                 title,
// //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 10),
// //               Text(
// //                 value,
// //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //               ),
// //               SizedBox(height: 5),
// //               Text(
// //                 change,
// //                 style: TextStyle(
// //                   fontSize: 16,
// //                   color: change.contains('-') ? Colors.red : Colors.green,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }

// //   // Function to build the question list
// //   Widget _buildQuestionList() {
// //     return GestureDetector(
// //       onTap: () => _showQuestionDetailsDialog(
// //                   context, question),
// //       child: Column(
// //         children: questions.map((question) {
// //           return Column(
// //             children: [
// //               Padding(
// //                 padding: const EdgeInsets.only(left: 25.0),
// //                 child: Container(
// //                   margin: EdgeInsets.symmetric(vertical: 8),
// //                   child: Padding(
// //                     padding: const EdgeInsets.all(1.0),
// //                     child: Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Expanded(
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 question['title'],
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.bold,
// //                                 ),
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                               SizedBox(height: 5),
// //                               Text(
// //                                 question['description'],
// //                                 style: TextStyle(color: Colors.black87),
// //                                 overflow: TextOverflow.ellipsis,
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                         SizedBox(width: 5),
// //                         Column(
// //                           children: [
// //                             Text(
// //                               'Question by:',
// //                               style: TextStyle(color: Colors.grey),
// //                             ),
// //                             Text(
// //                               'Trainer ID: ${question['added_by']}',
// //                               style: TextStyle(color: Colors.grey),
// //                             ),
// //                           ],
// //                         ),
// //                         Padding(
// //                           padding: const EdgeInsets.all(18.0),
// //                           child: Row(
// //                             children: [
// //                               // Approve button
// //                               ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(5)),
// //                                   backgroundColor:
// //                                       const Color.fromARGB(255, 228, 243, 229),
// //                                 ),
// //                                 onPressed: () {
// //                                   updateQuestionStatus(
// //                                       question['id'], 'approved');
// //                                 },
// //                                 child: Text(
// //                                   'Approve',
// //                                   style: TextStyle(color: Colors.green),
// //                                 ),
// //                               ),
// //                               SizedBox(width: 10),
// //                               // Reject button
// //                               ElevatedButton(
// //                                 onPressed: () {
// //                                   updateQuestionStatus(
// //                                       question['id'], 'rejected');
// //                                 },
// //                                 child: Text(
// //                                   'Reject',
// //                                   style: TextStyle(color: Colors.red),
// //                                 ),
// //                                 style: ElevatedButton.styleFrom(
// //                                   shape: RoundedRectangleBorder(
// //                                       borderRadius: BorderRadius.circular(5)),
// //                                   backgroundColor:
// //                                       const Color.fromARGB(255, 242, 217, 215),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Divider(),
// //             ],
// //           );
// //         }).toList(),
// //       ),
// //     );
// //   }

// //   // Widget to display when there are no questions pending approval
// //   Widget _buildNoQuestionsWidget() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           SizedBox(height: 20),
// //           Text(
// //             'No Pending Questions',
// //             style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //                 color: Colors.black54),
// //           ),
// //           SizedBox(height: 10),
// //           ElevatedButton(
// //             onPressed: fetchPendingQuestions, // Allow the user to refresh
// //             child: Text("Refresh"),
// //           ),
// //           SizedBox(height: 10),
// //           Container(
// //             width: MediaQuery.of(context).size.width * 0.5,
// //             height: MediaQuery.of(context).size.height * 0.9,
// //             child: Image.asset(
// //               fit: BoxFit.fitWidth,
// //               'assets/no_questions.png',
// //               // height: MediaQuery.of(context).size.height * 0.3,
// //               // width: MediaQuery.of(context).size.width * 0.5,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // import 'package:flutter/material.dart';
// // // import 'dart:convert'; // For JSON encoding/decoding
// // // import 'package:http/http.dart' as http;

// // // class HomeScreen extends StatefulWidget {
// // //   @override
// // //   _HomeScreenState createState() => _HomeScreenState();
// // // }

// // // class _HomeScreenState extends State<HomeScreen> {
// // //   List<dynamic> questions = []; // List to store pending questions
// // //   bool isLoading = true;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     fetchPendingQuestions();
// // //   }

// // //   // Function to fetch pending questions
// // //   Future<void> fetchPendingQuestions() async {
// // //     final response = await http.get(
// // //         Uri.parse('http://localhost:3000/questions/getAll?status=pending'));

// // //     if (response.statusCode == 200) {
// // //       setState(() {
// // //         questions = json.decode(response.body);
// // //         isLoading = false;
// // //       });
// // //     } else {
// // //       throw Exception('Failed to load questions');
// // //     }
// // //   }

// // //   // Function to approve or reject a question
// // //   Future<void> updateQuestionStatus(int questionId, String status) async {
// // //     final response = await http.put(
// // //       Uri.parse('http://localhost:3000/questions/update/$questionId'),
// // //       headers: <String, String>{
// // //         'Content-Type': 'application/json; charset=UTF-8',
// // //       },
// // //       body: jsonEncode(<String, String>{
// // //         'approval_status': status,
// // //       }),
// // //     );

// // //     if (response.statusCode == 200) {
// // //       print('Question $questionId updated to $status');
// // //       fetchPendingQuestions(); // Refresh the questions list
// // //     } else {
// // //       throw Exception('Failed to update question');
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SingleChildScrollView(
// // //       child: Column(
// // //         crossAxisAlignment: CrossAxisAlignment.start,
// // //         children: [
// // //           SizedBox(height: 15),
// // //           // Three Boxes Section
// // //           Row(
// // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //             children: [
// // //               _buildBox(context, 'Insights', 'View Insights', '+4.75%'),
// // //               _buildBox(context, 'Overdue invoices', '\$12,787.00', '+54.02%'),
// // //               _buildBox(context, 'Expenses', '\$30,156.00', '+10.18%'),
// // //             ],
// // //           ),
// // //           SizedBox(height: 20),
// // //           // Questions for Approval Section
// // //           Container(
// // //             color: const Color.fromARGB(255, 246, 242, 246),
// // //             height: 50,
// // //             width: MediaQuery.of(context).size.width,
// // //             child: Row(
// // //               children: [
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(left: 15.0),
// // //                   child: Text(
// // //                     'Questions for Approval',
// // //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
// // //                   ),
// // //                 ),
// // //                 Spacer(),
// // //                 Padding(
// // //                   padding: const EdgeInsets.only(right: 15.0),
// // //                   child: TextButton(onPressed: () {}, child: Text("View All")),
// // //                 )
// // //               ],
// // //             ),
// // //           ),
// // //           SizedBox(height: 10),
// // //           isLoading
// // //               ? Center(child: CircularProgressIndicator())
// // //               : _buildQuestionList(), // Show question list once loaded
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // Function to build the three boxes
// // //   Widget _buildBox(
// // //       BuildContext context, String title, String value, String change) {
// // //     return Expanded(
// // //       child: Container(
// // //         decoration: BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [
// // //               const Color.fromARGB(255, 249, 229, 236).withOpacity(0.3),
// // //               Colors.white.withOpacity(0.5),
// // //             ],
// // //             begin: Alignment.topLeft,
// // //             end: Alignment.bottomRight,
// // //             stops: const [0.1, 0.9],
// // //           ),
// // //           border: Border.all(width: 0.08, color: Colors.grey),
// // //         ),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(16.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               Text(
// // //                 title,
// // //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // //               ),
// // //               SizedBox(height: 10),
// // //               Text(
// // //                 value,
// // //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // //               ),
// // //               SizedBox(height: 5),
// // //               Text(
// // //                 change,
// // //                 style: TextStyle(
// // //                   fontSize: 16,
// // //                   color: change.contains('-') ? Colors.red : Colors.green,
// // //                 ),
// // //               ),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   // Function to build the question list
// // //   Widget _buildQuestionList() {
// // //     return Column(
// // //       children: questions.map((question) {
// // //         return Column(
// // //           children: [
// // //             Padding(
// // //               padding: const EdgeInsets.only(left: 25.0),
// // //               child: Container(
// // //                 margin: EdgeInsets.symmetric(vertical: 8),
// // //                 child: Padding(
// // //                   padding: const EdgeInsets.all(1.0),
// // //                   child: Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       Expanded(
// // //                         child: Column(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                           children: [
// // //                             Text(
// // //                               question['title'],
// // //                               style: TextStyle(
// // //                                 fontSize: 16,
// // //                                 fontWeight: FontWeight.bold,
// // //                               ),
// // //                               overflow: TextOverflow.ellipsis,
// // //                             ),
// // //                             SizedBox(height: 5),
// // //                             Text(
// // //                               question['description'],
// // //                               style: TextStyle(color: Colors.black87),
// // //                               overflow: TextOverflow.ellipsis,
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                       SizedBox(width: 5),
// // //                       Column(
// // //                         children: [
// // //                           Text(
// // //                             'Question by:',
// // //                             style: TextStyle(color: Colors.grey),
// // //                           ),
// // //                           Text(
// // //                             'Trainer ID: ${question['added_by']}',
// // //                             style: TextStyle(color: Colors.grey),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                       Padding(
// // //                         padding: const EdgeInsets.all(18.0),
// // //                         child: Row(
// // //                           children: [
// // //                             // Approve button
// // //                             ElevatedButton(
// // //                               style: ElevatedButton.styleFrom(
// // //                                 shape: RoundedRectangleBorder(
// // //                                     borderRadius: BorderRadius.circular(5)),
// // //                                 backgroundColor:
// // //                                     const Color.fromARGB(255, 228, 243, 229),
// // //                               ),
// // //                               onPressed: () {
// // //                                 updateQuestionStatus(
// // //                                     question['id'], 'approved');
// // //                               },
// // //                               child: Text(
// // //                                 'Approve',
// // //                                 style: TextStyle(color: Colors.green),
// // //                               ),
// // //                             ),
// // //                             SizedBox(width: 10),
// // //                             // Reject button
// // //                             ElevatedButton(
// // //                               onPressed: () {
// // //                                 updateQuestionStatus(
// // //                                     question['id'], 'rejected');
// // //                               },
// // //                               child: Text(
// // //                                 'Reject',
// // //                                 style: TextStyle(color: Colors.red),
// // //                               ),
// // //                               style: ElevatedButton.styleFrom(
// // //                                 shape: RoundedRectangleBorder(
// // //                                     borderRadius: BorderRadius.circular(5)),
// // //                                 backgroundColor:
// // //                                     const Color.fromARGB(255, 242, 217, 215),
// // //                               ),
// // //                             ),
// // //                           ],
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //             Divider(),
// // //           ],
// // //         );
// // //       }).toList(),
// // //     );
// // //   }
// // // }

// // // // import 'package:flutter/material.dart';

// // // // class HomeScreen extends StatelessWidget {
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return SingleChildScrollView(
// // // //       child: Column(
// // // //         crossAxisAlignment: CrossAxisAlignment.start,
// // // //         children: [
// // // //           SizedBox(
// // // //             height: 15,
// // // //           ),
// // // //           // Three Boxes Section
// // // //           Row(
// // // //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //             children: [
// // // //               _buildBox(context, 'Insights', 'View Insights', '+4.75%'),
// // // //               _buildBox(context, 'Overdue invoices', '\$12,787.00', '+54.02%'),
// // // //               _buildBox(context, 'Expenses', '\$30,156.00', '+10.18%'),
// // // //             ],
// // // //           ),
// // // //           SizedBox(height: 20),
// // // //           // Questions for Approval Section
// // // //           Container(
// // // //             color: const Color.fromARGB(255, 246, 242, 246),
// // // //             height: 50,
// // // //             width: MediaQuery.of(context).size.width * 0.99999,
// // // //             child: Row(
// // // //               children: [
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.only(left: 15.0),
// // // //                   child: Text(
// // // //                     'Questions for Approval',
// // // //                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
// // // //                   ),
// // // //                 ),
// // // //                 Spacer(),
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.only(right: 15.0),
// // // //                   child: TextButton(onPressed: () {}, child: Text("View All")),
// // // //                 )
// // // //               ],
// // // //             ),
// // // //           ),
// // // //           SizedBox(height: 10),
// // // //           _buildQuestionList(),
// // // //         ],
// // // //       ),
// // // //     );
// // // //   }

// // // //   // Function to build the three boxes
// // // //   Widget _buildBox(
// // // //       BuildContext context, String title, String value, String change) {
// // // //     return Expanded(
// // // //       child: Container(
// // // //         decoration: BoxDecoration(
// // // //           gradient: LinearGradient(
// // // //             colors: [
// // // //               const Color.fromARGB(255, 249, 229, 236)
// // // //                   .withOpacity(0.3), // Start with a stronger pinkish opacity
// // // //               Colors.white
// // // //                   .withOpacity(0.5), // Transition to white with more opacity
// // // //             ],
// // // //             begin: Alignment.topLeft, // The gradient starts from the top left
// // // //             end: Alignment.bottomRight, // and ends at the bottom right
// // // //             stops: const [
// // // //               0.1,
// // // //               0.9
// // // //             ], // Stops determine where each color appears in the gradient
// // // //           ),
// // // //           border: Border.all(width: 0.08, color: Colors.grey),
// // // //         ),
// // // //         // elevation: 1,
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(16.0),
// // // //           child: Column(
// // // //             crossAxisAlignment: CrossAxisAlignment.start,
// // // //             children: [
// // // //               Text(
// // // //                 title,
// // // //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// // // //               ),
// // // //               SizedBox(height: 10),
// // // //               Text(
// // // //                 value,
// // // //                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// // // //               ),
// // // //               SizedBox(height: 5),
// // // //               Text(
// // // //                 change,
// // // //                 style: TextStyle(
// // // //                   fontSize: 16,
// // // //                   color: change.contains('-') ? Colors.red : Colors.green,
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // //   // Dummy function for questions approval list
// // // //   Widget _buildQuestionList() {
// // // //     return Column(
// // // //       children: List.generate(10, (index) {
// // // //         return Column(
// // // //           children: [
// // // //             Padding(
// // // //               padding: const EdgeInsets.only(left: 25.0),
// // // //               child: Container(
// // // //                 // color: Colors.red,
// // // //                 margin: EdgeInsets.symmetric(vertical: 8),
// // // //                 child: Padding(
// // // //                   padding: const EdgeInsets.all(1.0),
// // // //                   child: Row(
// // // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                     children: [
// // // //                       Expanded(
// // // //                         child: Column(
// // // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // // //                           children: [
// // // //                             // Title and Trainer Row
// // // //                             Row(
// // // //                               crossAxisAlignment: CrossAxisAlignment.start,
// // // //                               children: [
// // // //                                 Flexible(
// // // //                                   child: Padding(
// // // //                                     padding: const EdgeInsets.only(right: 25.0),
// // // //                                     child: Text(
// // // //                                       'Question  is odd and odd numbers are weird, so print Weird. is odd and odd numbers are weird, so print Weird. is odd and odd numbers are weird, so print Weird. $index',
// // // //                                       style: TextStyle(
// // // //                                         fontSize: 16,
// // // //                                         fontWeight: FontWeight.bold,
// // // //                                       ),
// // // //                                       overflow: TextOverflow
// // // //                                           .ellipsis, // Ensures text doesn't overflow
// // // //                                       // maxLines:
// // // //                                       //     1, // Limits the title to 2 lines if it's long
// // // //                                     ),
// // // //                                   ),
// // // //                                 ),
// // // //                               ],
// // // //                             ),
// // // //                             SizedBox(height: 5),
// // // //                             Text(
// // // //                               'This is a short description of the question...',
// // // //                               style: TextStyle(color: Colors.black87),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       SizedBox(width: 5),
// // // //                       Padding(
// // // //                         padding: const EdgeInsets.only(left: 20.0, right: 100),
// // // //                         child: Column(
// // // //                           children: [
// // // //                             Text(
// // // //                               'Question by:',
// // // //                               style: TextStyle(color: Colors.grey),
// // // //                             ),
// // // //                             Text(
// // // //                               'Trainer Name $index',
// // // //                               style: TextStyle(color: Colors.grey),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                       Padding(
// // // //                         padding: const EdgeInsets.all(18.0),
// // // //                         child: Row(
// // // //                           children: [
// // // //                             // Approve button
// // // //                             ElevatedButton(
// // // //                               style: ElevatedButton.styleFrom(
// // // //                                 shape: RoundedRectangleBorder(
// // // //                                     borderRadius: BorderRadius.circular(5)),
// // // //                                 backgroundColor:
// // // //                                     const Color.fromARGB(255, 228, 243, 229),
// // // //                               ),
// // // //                               onPressed: () {
// // // //                                 // API call to approve the question
// // // //                               },
// // // //                               child: Text(
// // // //                                 'Approve',
// // // //                                 style: TextStyle(color: Colors.green),
// // // //                               ),
// // // //                             ),
// // // //                             SizedBox(width: 10),
// // // //                             // Reject button
// // // //                             ElevatedButton(
// // // //                               onPressed: () {
// // // //                                 // API call to reject the question
// // // //                               },
// // // //                               child: Text(
// // // //                                 'Reject',
// // // //                                 style: TextStyle(
// // // //                                     color:
// // // //                                         const Color.fromARGB(255, 217, 26, 13)),
// // // //                               ),
// // // //                               style: ElevatedButton.styleFrom(
// // // //                                 shape: RoundedRectangleBorder(
// // // //                                     borderRadius: BorderRadius.circular(5)),
// // // //                                 backgroundColor:
// // // //                                     const Color.fromARGB(255, 242, 217, 215),
// // // //                               ),
// // // //                             ),
// // // //                           ],
// // // //                         ),
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //             ),
// // // //             Divider(), // Divider after each question
// // // //           ],
// // // //         );
// // // //       }),
// // // //     );
// // // //   }
// // // // }
