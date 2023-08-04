import 'dart:convert';

import 'package:book_management/classes/book.dart';
import 'package:book_management/components/future.dart';
import 'package:book_management/constants/api_strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: http.get(Uri.parse(APIStrings.BOOKS_API)),
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (data != null) {
                  debugPrint('status code => ${data.statusCode}');
                  debugPrint('response body => ${data.body}');
                  if (data.statusCode == 200) {
                    var body = data.body;
                    List response = jsonDecode(body);
                    List<Book> books = [];
                    if (response.isEmpty) {
                      return FutureComponents.emptyDataWidget();
                    }
                    for (Map<String, dynamic> bookData in response) {
                      Book book = Book.fromMap(bookData);
                      books.add(book);
                    }
                    if (books.isEmpty) {
                      return FutureComponents.emptyDataWidget();
                    } else {
                      return ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (_, index) {
                          Book book = books[index];
                          return ListTile(
                            title: Text(book.title),
                            subtitle: Text(book.description),
                          );
                        },
                      );
                    }
                  }
                }
                return FutureComponents.errorWidget();
              }
              if (snapshot.hasError) {
                return FutureComponents.errorWidget();
              }
              return FutureComponents.loadingWidget();
            }),
      ),
    );
  }
}
