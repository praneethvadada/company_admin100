import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // For image picking

class CollegesPanel extends StatefulWidget {
  @override
  _CollegesPanelState createState() => _CollegesPanelState();
}

class _CollegesPanelState extends State<CollegesPanel> {
  List<dynamic> colleges = [];
  bool isLoading = true;
  File? _image; // For storing the selected image

  @override
  void initState() {
    super.initState();
    fetchColleges();
  }

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600; // Define mobile screen size
  }

  // UI for Add/Edit college dialog
  Future<void> showCollegeDialog(
      {required bool isEdit, dynamic college}) async {
    String name = isEdit ? college['name'] : '';
    String code = isEdit ? college['code'] : '';
    String state = isEdit ? college['state'] : '';
    String city = isEdit ? college['city'] : '';
    String email = isEdit ? college['email'] ?? '' : ''; // Optional email
    String password =
        isEdit ? '' : ''; // Password won't be editable for existing

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit College' : 'Add College'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(labelText: 'College Name'),
                  onChanged: (value) => name = value,
                ),
                TextField(
                  controller: TextEditingController(text: code),
                  decoration: InputDecoration(labelText: 'College Code'),
                  onChanged: (value) => code = value,
                ),
                TextField(
                  controller: TextEditingController(text: state),
                  decoration: InputDecoration(labelText: 'State'),
                  onChanged: (value) => state = value,
                ),
                TextField(
                  controller: TextEditingController(text: city),
                  decoration: InputDecoration(labelText: 'City'),
                  onChanged: (value) => city = value,
                ),
                TextField(
                  controller: TextEditingController(text: email),
                  decoration: InputDecoration(labelText: 'Email'),
                  onChanged: (value) => email = value,
                ),
                if (!isEdit) // Only show password when adding a new college
                  TextField(
                    controller: TextEditingController(text: password),
                    decoration: InputDecoration(labelText: 'Password'),
                    onChanged: (value) => password = value,
                    obscureText: true,
                  ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: pickImage,
                  icon: Icon(Icons.upload),
                  label: Text(_image == null ? 'Upload Logo' : 'Change Logo'),
                ),
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isEdit ? 'Save' : 'Add'),
              onPressed: () {
                if (isEdit) {
                  editCollege(
                      college['id'], name, code, state, city, email, password);
                } else {
                  addCollege(name, code, state, city, email, password);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteCollege(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/colleges/delete/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('College deleted successfully!')),
        );
        setState(() {
          fetchColleges(); // Refresh the list after deletion
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to delete college: ${response.statusCode}')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  // Fetch colleges from API
  Future<void> fetchColleges() async {
    final response =
        await http.get(Uri.parse('http://localhost:3000/colleges/getAll'));
    if (response.statusCode == 200) {
      setState(() {
        colleges = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load colleges');
    }
  }

  // Add a new college
  Future<void> addCollege(String name, String code, String state, String city,
      String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/colleges/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'code': code,
        'state': state,
        'city': city,
        'email': email,
        'password': password,
        'logo': _image != null ? 'image_path.png' : null, // Mock image path
      }),
    );
    if (response.statusCode == 201) {
      fetchColleges(); // Refresh the list
    } else {
      throw Exception('Failed to add college');
    }
  }

  // Edit an existing college
  Future<void> editCollege(int id, String name, String code, String state,
      String city, String email, String password) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/colleges/update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'code': code,
        'state': state,
        'city': city,
        'email': email,
        'password': password,
        'logo': _image != null ? 'image_path.png' : null, // Mock image path
      }),
    );
    if (response.statusCode == 200) {
      fetchColleges(); // Refresh the list
    } else {
      throw Exception('Failed to update college');
    }
  }

  // Function to pick an image
  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

// Function to show the Manage Batches dialog for a college
  Future<void> showManageBatchesDialog(
      int collegeId, String collegeName) async {
    List<dynamic> batches = [];
    bool isBatchesLoading = true;

    print("Opening Manage Batches for College ID: $collegeId");

    // Fetch batches based on college id
    Future<void> fetchBatches() async {
      print("Fetching batches for College ID: $collegeId");
      try {
        final response = await http.get(
          Uri.parse('http://localhost:3000/batches/colleges/$collegeId'),
        );

        print("Response status: ${response.statusCode}");

        if (response.statusCode == 200) {
          batches = json.decode(response.body);
          print("Batches fetched: ${batches.length}");
          isBatchesLoading = false;
          setState(() {}); // Update state when batches are loaded
        } else {
          print("Failed to load batches, status code: ${response.statusCode}");
          throw Exception('Failed to load batches');
        }
      } catch (error) {
        print("Error while fetching batches: $error");
      }
    }

    // Function to show a dialog for adding or editing a batch
    Future<void> showBatchDialog({
      required bool isEdit,
      dynamic batch,
      required void Function() refreshBatches,
    }) async {
      String batchName = isEdit ? batch['name'] : '';

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Batch' : 'Add Batch'),
            content: TextField(
              onChanged: (value) => batchName = value,
              decoration: InputDecoration(
                labelText: 'Batch Name',
                hintText: 'Enter batch name',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(isEdit ? 'Save' : 'Add'),
                onPressed: () async {
                  if (batchName.isNotEmpty) {
                    try {
                      if (isEdit) {
                        // Edit existing batch
                        final response = await http.put(
                          Uri.parse(
                              'http://localhost:3000/batches/update/${batch['id']}'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({'name': batchName}),
                        );
                        if (response.statusCode == 200) {
                          print('Batch edited successfully');
                          refreshBatches();
                          Navigator.of(context).pop(); // Close the dialog
                        } else {
                          print('Failed to edit batch');
                        }
                      } else {
                        // Add new batch
                        final response = await http.post(
                          Uri.parse('http://localhost:3000/batches/add'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({
                            'college_id': collegeId,
                            'name': batchName,
                          }),
                        );
                        if (response.statusCode == 201) {
                          refreshBatches(); // Refresh the batch list immediately
                          Navigator.of(context)
                              .pop(); // Close the add batch dialog
                        } else {
                          print('Failed to add batch');
                        }
                      }
                    } catch (error) {
                      print('Error while adding/editing batch: $error');
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    }

// Function to delete a batch and reopen the dialog after deletion
    Future<void> deleteBatch(int batchId) async {
      try {
        final response = await http.delete(
          Uri.parse('http://localhost:3000/batches/delete/$batchId'),
        );
        if (response.statusCode == 200) {
          print('Batch deleted successfully');

          // Close the current dialog
          Navigator.of(context).pop();

          // Fetch the updated batch list
          await fetchBatches();

          // Reopen the popup immediately with the updated list
          Future.delayed(Duration(milliseconds: 100), () {
            // showBatchesDialog(); // Call the function to reopen the dialog with the updated list
          });
        } else {
          print(
              'Failed to delete batch with status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error while deleting batch: $error');
      }
    }

// Function to open the batch dialog (reusable for opening the dialog)
    void showBatchesDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Manage Batches'),
            content: isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: batches.map((batch) {
                        return ListTile(
                          title: Text(batch['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showBatchesDialog();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  deleteBatch(
                                      batch['id']); // Delete and refresh dialog
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            actions: [
              TextButton(
                onPressed: () {
                  showBatchesDialog(); // Open the "Add Batch" dialog
                },
                child: Text('Add Batch'),
              ),
            ],
          );
        },
      );
    }

    // Load the batches when opening the dialog
    await fetchBatches();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      title: Text('Manage Batches for $collegeName'),
                      automaticallyImplyLeading: false,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showBatchDialog(
                            isEdit: false,
                            batch: null,
                            refreshBatches: () async {
                              await fetchBatches(); // Fetch batches after adding a batch
                              setState(
                                  () {}); // Update the state to reflect new batches
                            },
                          );
                        },
                        child: Text('Add Batch'),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: isBatchesLoading
                            ? Center(child: CircularProgressIndicator())
                            : batches.isEmpty
                                ? Center(child: Text('No batches available'))
                                : ListView.builder(
                                    itemCount: batches.length,
                                    itemBuilder: (context, index) {
                                      var batch = batches[index];
                                      return ListTile(
                                        title: Text(batch['name']),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                showBatchDialog(
                                                  isEdit: true,
                                                  batch: batch,
                                                  refreshBatches: () async {
                                                    await fetchBatches();
                                                    setState(() {});
                                                  },
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                deleteBatch(batch['id']);
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCollegeTable() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: colleges.map((college) {
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        college['logo'] != null
                            ? Image.network(
                                'http://localhost:3000/path_to_college_logo/${college['logo']}',
                                height: 50,
                                width: 50,
                              )
                            : Icon(Icons.photo_size_select_actual_rounded),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('College Name: ${college['name']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('College Code: ${college['code']}',
                                style: TextStyle(color: Colors.grey[600])),
                            Text(
                                'State: ${college['state']}, City: ${college['city']}',
                                style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            showCollegeDialog(isEdit: true, college: college);
                          },
                          child: Text('Edit',
                              style: TextStyle(color: Colors.blue)),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            deleteCollege(college['id']);
                          },
                          child: Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            showManageBatchesDialog(
                                college['id'], college['name']);
                          },
                          child: Text('Manage Batches',
                              style: TextStyle(color: Colors.purple)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey[400]),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Colleges',
                  // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  style: TextStyle(
                      fontSize: isMobile(context) ? 12 : 14,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showCollegeDialog(isEdit: false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Add College'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'A list of all the colleges in your account including their name, code, state, and city.',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(child: _buildCollegeTable()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
