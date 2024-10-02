// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class BatchesPanel extends StatefulWidget {
//   final int collegeId;
//   final String collegeName;

//   BatchesPanel({required this.collegeId, required this.collegeName});

//   @override
//   _BatchesPanelState createState() => _BatchesPanelState();
// }

// class _BatchesPanelState extends State<BatchesPanel> {
//   List<dynamic> batches = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchBatches();
//   }

//   // Fetch batches based on college id
//   Future<void> fetchBatches() async {
//     final response = await http.get(Uri.parse(
//         'http://localhost:3000/batches/colleges/${widget.collegeId}'));
//     if (response.statusCode == 200) {
//       setState(() {
//         batches = json.decode(response.body);
//         isLoading = false;
//       });
//     } else {
//       throw Exception('Failed to load batches');
//     }
//   }

//   // UI for the popup dialog
//   Future<void> showBatchesDialog(BuildContext context) async {
//     showDialog(
//       context: context,
//       barrierDismissible:
//           true, // Allows the user to tap outside to dismiss the dialog
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.8,
//             height: MediaQuery.of(context).size.height * 0.8,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 AppBar(
//                   title: Text('Manage Batches for ${widget.collegeName}'),
//                   automaticallyImplyLeading:
//                       false, // Remove default back button
//                   actions: [
//                     IconButton(
//                       icon: Icon(Icons.close),
//                       onPressed: () {
//                         Navigator.of(context).pop(); // Close the dialog
//                       },
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Container(
//                       color: Colors.pink[50],
//                       child: isLoading
//                           ? Center(child: CircularProgressIndicator())
//                           : ListView.builder(
//                               itemCount: batches.length,
//                               itemBuilder: (context, index) {
//                                 var batch = batches[index];
//                                 return ListTile(
//                                   title: Text(batch['name']),
//                                   trailing: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.edit,
//                                             color: Colors.blue),
//                                         onPressed: () {
//                                           // Handle batch edit logic
//                                         },
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.delete,
//                                             color: Colors.red),
//                                         onPressed: () {
//                                           // Handle batch delete logic
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // UI for Add/Edit batch dialog (optional if you need to add this for Add/Edit actions)
//   Future<void> showBatchDialog({required bool isEdit, dynamic batch}) async {
//     String batchName = isEdit ? batch['name'] : '';

//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(isEdit ? 'Edit Batch' : 'Add Batch'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 TextField(
//                   controller: TextEditingController(text: batchName),
//                   decoration: InputDecoration(labelText: 'Batch Name'),
//                   onChanged: (value) => batchName = value,
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text(isEdit ? 'Save' : 'Add'),
//               onPressed: () {
//                 if (isEdit) {
//                   // Handle batch edit logic
//                 } else {
//                   // Handle batch add logic
//                 }
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => showBatchesDialog(context),
//       child: Text('Manage Batches'),
//     );
//   }
// }

// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;

// // class BatchesPanel extends StatefulWidget {
// //   final int collegeId;
// //   final String collegeName;
// //   late final VoidCallback onBackPressed; // Define the onBackPressed callback

// //   BatchesPanel({required this.collegeId, required this.collegeName});

// //   @override
// //   _BatchesPanelState createState() => _BatchesPanelState();
// // }

// // class _BatchesPanelState extends State<BatchesPanel> {
// //   List<dynamic> batches = [];
// //   bool isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchBatches();
// //   }

// //   // Fetch batches based on college id
// //   Future<void> fetchBatches() async {
// //     final response = await http.get(Uri.parse(
// //         'http://localhost:3000/batches/colleges/${widget.collegeId}'));
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         batches = json.decode(response.body);
// //         isLoading = false;
// //       });
// //     } else {
// //       throw Exception('Failed to load batches');
// //     }
// //   }

// //   // Add a new batch
// //   Future<void> addBatch(String batchName) async {
// //     final response = await http.post(
// //       Uri.parse('http://localhost:3000/batches/add'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'college_id': widget.collegeId,
// //         'name': batchName,
// //       }),
// //     );
// //     if (response.statusCode == 201) {
// //       fetchBatches(); // Refresh the list
// //     } else {
// //       throw Exception('Failed to add batch');
// //     }
// //   }

// //   // Edit an existing batch
// //   Future<void> editBatch(int batchId, String batchName) async {
// //     final response = await http.put(
// //       Uri.parse('http://localhost:3000/batches/update/$batchId'),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'name': batchName}),
// //     );
// //     if (response.statusCode == 200) {
// //       fetchBatches(); // Refresh the list
// //     } else {
// //       throw Exception('Failed to update batch');
// //     }
// //   }

// //   // Delete a batch
// //   Future<void> deleteBatch(int batchId) async {
// //     final response = await http.delete(
// //       Uri.parse('http://localhost:3000/batches/delete/$batchId'),
// //       headers: {'Content-Type': 'application/json'},
// //     );
// //     if (response.statusCode == 200) {
// //       fetchBatches(); // Refresh the list
// //     } else {
// //       throw Exception('Failed to delete batch');
// //     }
// //   }

// //   // UI for Add/Edit batch dialog
// //   Future<void> showBatchDialog({required bool isEdit, dynamic batch}) async {
// //     String batchName = isEdit ? batch['name'] : '';

// //     return showDialog<void>(
// //       context: context,
// //       barrierDismissible: false,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text(isEdit ? 'Edit Batch' : 'Add Batch'),
// //           content: SingleChildScrollView(
// //             child: ListBody(
// //               children: <Widget>[
// //                 TextField(
// //                   controller: TextEditingController(text: batchName),
// //                   decoration: InputDecoration(labelText: 'Batch Name'),
// //                   onChanged: (value) => batchName = value,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               child: Text('Cancel'),
// //               onPressed: () {
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //             TextButton(
// //               child: Text(isEdit ? 'Save' : 'Add'),
// //               onPressed: () {
// //                 if (isEdit) {
// //                   editBatch(batch['id'], batchName);
// //                 } else {
// //                   addBatch(batchName);
// //                 }
// //                 Navigator.of(context).pop();
// //               },
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }

// //   // Build the table for batches
// //   Widget _buildBatchTable() {
// //     return DataTable(
// //       columns: [
// //         DataColumn(label: Text('Name')),
// //         DataColumn(label: Text('Actions')),
// //       ],
// //       rows: batches.map<DataRow>((batch) {
// //         return DataRow(cells: [
// //           DataCell(Text(batch['name'])),
// //           DataCell(Row(
// //             children: [
// //               TextButton(
// //                 onPressed: () {
// //                   showBatchDialog(isEdit: true, batch: batch);
// //                 },
// //                 child: Text('Edit', style: TextStyle(color: Colors.blue)),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   deleteBatch(batch['id']);
// //                 },
// //                 child: Text('Delete', style: TextStyle(color: Colors.red)),
// //               ),
// //             ],
// //           )),
// //         ]);
// //       }).toList(),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Manage Batches for ${widget.collegeName}'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(
// //                   'Manage Batches',
// //                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //                 ),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     showBatchDialog(isEdit: false);
// //                   },
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Colors.purple[100],
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(30),
// //                     ),
// //                   ),
// //                   child: Text('Add Batch'),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               'A list of all the batches for this college.',
// //               style: TextStyle(fontSize: 14, color: Colors.black54),
// //             ),
// //             SizedBox(height: 20),
// //             Expanded(
// //               child: Container(
// //                 color: Colors.pink[50],
// //                 child: isLoading
// //                     ? Center(child: CircularProgressIndicator())
// //                     : SingleChildScrollView(
// //                         scrollDirection: Axis.horizontal,
// //                         child: _buildBatchTable(),
// //                       ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
