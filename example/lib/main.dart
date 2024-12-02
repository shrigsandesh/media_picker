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
                  allowMultiple: true,
                  transitionBuilder: slideTransitionBuilder,
                  pickedMedias: (assetEntity) async {
                    final file = await assetEntity.first.file;
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NextPage(file: file!),
                      ));
                    }
                  },
                  albumTile: (context, alubms) {
                    return Container(
                      color: Colors.green,
                      child: Text("data: ${alubms.name}"),
                    );
                  },
                );
              },
              child: const Text("Pick Photos"),
            ),
            ElevatedButton(
              onPressed: () {
                showMediaPicker(
                  context: context,
                  allowMultiple: true,
                  checkedIconColor: Colors.green,
                  mediaTypes: {
                    MediaType.video,
                  },
                  pickedMedias: (assetEntity) {
                    log(assetEntity.toString());
                  },
                  pickedMediaBottomSheet: (context, albums) {
                    log(albums.length.toString());
                    if (albums.isNotEmpty) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                        height: 50,
                        child: Text(
                          "data ${albums.first.id}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                );
              },
              child: const Text("Pick videos"),
            ),
            ElevatedButton(
              onPressed: () {
                showMediaPicker(
                  context: context,
                  tabBarDecoration:
                      const TabBarDecoration(backgroundColor: Colors.red),
                  scaffoldBackgroundColor: Colors.red,
                  albumDropdownColor: Colors.red,
                  mediaTypes: {
                    MediaType.common,
                    MediaType.video,
                    MediaType.image
                  },
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
