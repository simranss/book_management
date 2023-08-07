import 'dart:convert';
import 'dart:io';

import 'package:book_management/classes/book.dart';
import 'package:book_management/constants/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeModel extends ChangeNotifier {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;

  Future<List<Book>> searchBooksByTitle(
      BuildContext context, String query) async {
    List<Book> books = [];
    try {
      final response =
          await http.get(Uri.parse('${APIStrings.BOOKS_BY_TITLE_API}/$query'));
      debugPrint('status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var body = response.body;
        List data = jsonDecode(body);
        if (data.isEmpty) {
          return [];
        }
        for (Map<String, dynamic> bookData in data) {
          Book book = Book.fromMap(bookData);
          books.add(book);
        }
        return books;
      }
    } on SocketException {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No Internet')));
      }
    } catch (err) {
      debugPrint('error: $err');
    }
    return books;
  }
}
