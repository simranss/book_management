import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../classes/book.dart';
import '../classes/keyword.dart';
import '../constants/api_strings.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          title: Text(book.title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: 'Author: ',
                        children: [
                          TextSpan(
                            text: book.author,
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Wrap(
                  children: [
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          '${book.pages} pages',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          book.releaseYear.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    (book.bookSeries != null)
                        ? Card(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                '${book.bookSeries} series',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          book.description,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: http.get(Uri.parse(
                      '${APIStrings.KEYWORDS_BY_BOOK_ID_API}/${book.id}')),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      var response = snapshot.data;
                      if (response != null) {
                        debugPrint('status code: ${response.statusCode}');
                        debugPrint('body: ${response.body}');
                        if (response.statusCode == 200) {
                          Map<String, dynamic> res = jsonDecode(response.body);
                          List<dynamic> data = res['data'];
                          return _keywordsSuccessWidget(data);
                        }
                      }
                    }
                    if (snapshot.hasError) {
                      debugPrint('error: ${snapshot.error}');
                      return const SizedBox();
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _keywordsSuccessWidget(List data) {
    List<Widget> keywordWidgets = [];
    for (Map<String, dynamic> keywordData in data) {
      Keyword keyword = Keyword.fromMap(keywordData);
      Widget keywordWidget = Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Text(
            keyword.keyword,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      );
      keywordWidgets.add(keywordWidget);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            'Keywords:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Wrap(
          children: keywordWidgets,
        ),
      ],
    );
  }
}
