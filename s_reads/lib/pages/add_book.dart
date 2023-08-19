import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../classes/author.dart';
import '../models/add_book.dart';

class AddBookPage extends StatelessWidget {
  const AddBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    final addBookModel = context.read<AddBookModel>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add a book'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 30,
            ),
            child: Form(
              key: addBookModel.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: addBookModel.titleController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: addBookModel.descriptionController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 5,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }
                      if (value.trim().length > 1000) {
                        return 'Maximum 1000 characters allowed';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Autocomplete<Author>(
                    fieldViewBuilder: (_, textEditingController, focusNode,
                        onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        onEditingComplete: onFieldSubmitted,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: 'Author',
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      );
                    },
                    optionsBuilder: (textEditingValue) async {
                      if (textEditingValue.text.trim().isNotEmpty) {
                        return await addBookModel.searchAuthorsByName(
                            context, textEditingValue.text.trim());
                      }
                      return [];
                    },
                    displayStringForOption: (author) => author.name,
                    onSelected: (author) {
                      debugPrint('author selected ${author.name}');
                      addBookModel.author = author;
                    },
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 250,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: addBookModel.pagesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            decoration: InputDecoration(
                              hintText: 'Pages',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.parse(value) < 1) {
                                return 'Invalid pages';
                              }
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          child: Selector<AddBookModel, DateTime>(
                            builder: (_, selectedDate, __) => YearPicker(
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now(),
                              selectedDate: selectedDate,
                              onChanged: (changedVal) {
                                debugPrint(changedVal.year.toString());
                                addBookModel.setSelectedDate(changedVal);
                              },
                            ),
                            selector: (_, model) => model.selectedDate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('add clicked');
                      if (addBookModel.formKey.currentState!.validate()) {
                        addBookModel.addBook(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
