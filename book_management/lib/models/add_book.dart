import 'dart:convert';
import 'dart:io';

import 'package:book_management/constants/api_strings.dart';
import 'package:book_management/utils/navigation_utils.dart';
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

  addBook(BuildContext context) async {
    debugPrint('title: ${titleController.text.trim()}');
    debugPrint('desc: ${descriptionController.text.trim()}');
    debugPrint('author: ${authorController.text.trim()}');
    debugPrint('pages: ${pagesController.text.trim()}');
    debugPrint('release year: ${selectedDate.year}');

    Map<String, String> dataToSend = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'author': authorController.text.trim(),
      'pages': pagesController.text.trim(),
      'release_year': selectedDate.year.toString(),
    };

    // add book
    try {
      var response =
          await http.post(Uri.parse(APIStrings.BOOK_API), body: dataToSend);
      debugPrint('status code: ${response.statusCode}');
      debugPrint('body: ${response.body}');
      Map<String, dynamic> body = jsonDecode(response.body);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(body['message'])));
      }
      if (response.statusCode == 200 && context.mounted) {
        NavigationUtils.pop(context);
      }
    } on SocketException {
      debugPrint('error: No internet');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Internet')));
      }
    } catch (err) {
      debugPrint('error: $err');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Something went wrong')));
      }
    }
  }
}
