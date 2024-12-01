import 'dart:developer';

import 'package:example/next_page.dart';
import 'package:flutter/material.dart';
import 'package:media_picker/media_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget slideTransitionBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    const begin = Offset(0.0, 1.0); // Start from the bottom
    const end = Offset.zero; // End at the top
    const curve = Curves.easeInOut;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                showMediaPicker(
                  context: context,
                  mediaType: MediaType.image,
                  transitionBuilder: slideTransitionBuilder,
                  allowMultiple: true,
                  pickedMedias: (assetEntity) async {
                    final file = await assetEntity.first.file;
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NextPage(file: file!),
                      ));
                    }
                  },
                );
              },
              child: const Text("Pick Photos"),
            ),
            ElevatedButton(
              onPressed: () {
                showMediaPicker(
                  context: context,
                  mediaType: MediaType.video,
                  pickedMedias: (assetEntity) {
                    log(assetEntity.toString());
                  },
                );
              },
              child: const Text("Pick videos"),
            ),
            ElevatedButton(
              onPressed: () {
                showMediaPicker(
                  context: context,
                  tabBarDecoration: const TabBarDecoration(
                    backgroundColor: Colors.red,
                    unselectedLabelStyle: TextStyle(color: Colors.red),
                  ),
                  pickedMedias: (assetEntity) {},
                );
              },
              child: const Text("Pick photos & videos"),
            ),
          ],
        ),
      ),
    );
  }
}
