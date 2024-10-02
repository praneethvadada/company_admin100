import 'package:flutter/material.dart';

class AdminWidget {
  static Widget textField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  static Widget elevatedButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  static Widget loadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget errorText(String errorMessage) {
    return Text(
      errorMessage,
      style: TextStyle(color: Colors.red),
    );
  }
}
