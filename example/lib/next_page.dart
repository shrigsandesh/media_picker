import 'dart:io';

import 'package:flutter/material.dart';

class NextPage extends StatelessWidget {
  const NextPage({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("image file"),
        ),
        body: Center(
          child: Image.file(file),
        ));
  }
}
