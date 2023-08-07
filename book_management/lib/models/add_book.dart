import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AddBookModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final pagesController = TextEditingController();
  final authorController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  setSelectedDate(DateTime val) {
    selectedDate = val;
    notifyListeners();
  }

  addBook() async {
    debugPrint('title: ${titleController.text.trim()}');
    debugPrint('desc: ${descriptionController.text.trim()}');
    debugPrint('author: ${authorController.text.trim()}');
    debugPrint('pages: ${pagesController.text.trim()}');
    debugPrint('release year: ${selectedDate.year}');
    // add book

    try {
      var response = http.post(Uri.parse(''));
    } on SocketException {
      debugPrint('Internet Issues');
    } catch (err) {
      debugPrint('err: $err');
    }
  }
}
