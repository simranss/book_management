import 'package:flutter/material.dart';

class AddBookModel extends ChangeNotifier {
  final formKey = GlobalKey<FormFieldState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final pagesController = TextEditingController();
  final authorController = TextEditingController();

  addBook() async {
    if (formKey.currentState!.validate()) {
      // add book
    }
  }
}
