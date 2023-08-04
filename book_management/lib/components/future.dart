import 'package:flutter/material.dart';

class FutureComponents {
  static Widget errorWidget() {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_rounded,
          color: Colors.red,
        ),
        Text('Error Occurred'),
      ],
    );
  }

  static Widget loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static Widget emptyDataWidget() {
    return const Center(
      child: Text('No data found'),
    );
  }
}
