import 'dart:convert';

import 'package:s_reads/classes/book.dart';
import 'package:s_reads/components/future.dart';
import 'package:s_reads/constants/api_strings.dart';
import 'package:s_reads/constants/shared_prefs_strings.dart';
import 'package:s_reads/models/add_book.dart';
import 'package:s_reads/models/home.dart';
import 'package:s_reads/pages/add_book.dart';
import 'package:s_reads/pages/book_details.dart';
import 'package:s_reads/utils/navigation_utils.dart';
import 'package:s_reads/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final homeModel = context.read<HomeModel>();
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Card(
              shadowColor: Colors.black45,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Autocomplete<Book>(
                fieldViewBuilder:
                    (_, textEditingController, focusNode, onFieldSubmitted) {
                  homeModel.searchController = textEditingController;
                  homeModel.searchFocusNode = focusNode;
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onEditingComplete: onFieldSubmitted,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 13,
                      ),
                      suffixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.black45,
                        size: 25,
                      ),
                      hintText: 'Search your book',
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  );
                },
                optionsBuilder: (textEditingValue) async {
                  if (textEditingValue.text.trim().isNotEmpty) {
                    return await homeModel.searchBooksByTitle(
                        context, textEditingValue.text.trim());
                  }
                  return [];
                },
                displayStringForOption: (book) =>
                    '${book.title} by ${book.author}',
                onSelected: (book) {
                  debugPrint('book selected ${book.title} --- ${book.author}');
                  homeModel.searchController.clear();
                  if (homeModel.searchFocusNode.hasFocus) {
                    homeModel.searchFocusNode.unfocus();
                  }
                  NavigationUtils.push(context, BookDetailsPage(book: book));
                },
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
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
                          return ListView.separated(
                            itemCount: books.length,
                            itemBuilder: (_, index) {
                              Book book = books[index];
                              return ListTile(
                                title: Text(
                                  '${book.title} by ${book.author}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'Series: ${book.bookSeries}\nPages: ${book.pages}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Text(book.releaseYear.toString()),
                                onTap: () => NavigationUtils.push(
                                  context,
                                  BookDetailsPage(book: book),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(thickness: 2),
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
                },
              ),
            ),
          ],
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  Widget _floatingActionButton() {
    return FutureBuilder<int?>(
      future: SharedPrefsUtils.getInt(SharedPrefsStrings.userAccessGroup),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var accessGroup = snapshot.data;
          if (accessGroup != null) {
            if (accessGroup == 1) {
              return _addBookFAB(context);
            }
          }
        }
        return _requestBookFAB();
      },
    );
  }

  Widget _requestBookFAB() {
    return FloatingActionButton(
      onPressed: () {
        debugPrint('request book clicked');
      },
      tooltip: 'Request a Book',
      child: const Icon(Icons.add),
    );
  }

  Widget _addBookFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        NavigationUtils.push(
          context,
          ChangeNotifierProvider<AddBookModel>(
            create: (_) => AddBookModel(),
            child: const AddBookPage(),
          ),
        );
      },
      tooltip: 'Add a Book',
      child: const Icon(Icons.add),
    );
  }
}
