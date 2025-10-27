import 'dart:io';

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
      debugShowCheckedModeBanner: false,
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
  Widget slideFromBottomTransitionBuilder(
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

  int sortScreenshotAlbumsFirst(AssetPathEntity a, AssetPathEntity b) {
    const screenshotName = "Screenshots";

    if (a.name == screenshotName && b.name != screenshotName) {
      return -1; // a comes before b
    } else if (a.name != screenshotName && b.name == screenshotName) {
      return 1; // b comes before a
    } else {
      return a.name.compareTo(b.name); // fallback to alphabetical order
    }
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
                  permissionState: PermissionState.authorized,
                  appBar: AppBar(),
                  transitionBuilder: slideFromBottomTransitionBuilder,
                  onMediaPicked: (assetEntity) async {
                    if (assetEntity.isNotEmpty) {
                      final file = await assetEntity.first.file;
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NextPage(file: file!),
                        ));
                      }
                    }
                  },
                  onClose: () {
                    // Handle close action
                  },
                  customAlbum: const MediaAlbum(
                    name: "Custom Album",
                    size: 1,
                    id: "custom_album_id",
                  ),
                  mediaGridBuilder: (context) => GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                      10,
                      (index) {
                        return Container(
                          color: Colors.blue,
                          margin: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              'Item $index',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  closeIconColor: Colors.red,
                  tabBuilder: (context, album, isSelected) => Text(
                    "${album.name}(${album.size})",
                    style: TextStyle(
                        color: isSelected ? Colors.red : Colors.amber),
                  ),
                  tabDecoration: const TabDecoration(),
                  customAlbumConfigs: [
                    CustomAlbumConfig(
                        album: const MediaAlbum(
                            id: 'id_1', name: "Album 1", size: 0),
                        builder: (context) => const CustomMediaGrid(
                              count: 2,
                            )),
                    CustomAlbumConfig(
                        album: const MediaAlbum(
                            id: 'id_2', name: "Album 2", size: 10),
                        builder: (context) => const CustomMediaGrid(
                              count: 3,
                            )),
                  ],
                  sortAlbumFunction: sortScreenshotAlbumsFirst,
                  crossAxisCount: 4,
                  pageSize: 50,
                  limitedPermissionBuilder: (context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      decoration: const BoxDecoration(color: Colors.blue),
                    );
                  },
                  assetGrouper: (assets) {
                    final grouped = <DateTime, List<AssetEntity>>{};

                    for (final media in assets) {
                      final created = media.createDateTime;
                      final dateKey = DateTime(
                        created.year,
                        created.month,
                        created.day,
                      );

                      grouped.putIfAbsent(dateKey, () => []).add(media);
                    }

                    return {for (final e in grouped.entries) e.key: e.value};
                  },
                  groupDateBuilder: (context, date) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                      color: Colors.red,
                      child: Text(
                        date.toString(),
                      ),
                    );
                  },
                );
              },
              child: const Text("Pick Media"),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomMediaGrid extends StatelessWidget {
  const CustomMediaGrid({
    super.key,
    required this.count,
    this.title,
  });

  final int count;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 4),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
              ),
            ),
          ],
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: count,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Clicked on Item $index")),
                    );
                  },
                  child: Stack(
                    children: [
                      // Media Thumbnail
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/sample1.jpg',
                            ), // Replace with real thumbnails
                            fit: BoxFit.cover,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),

                      // Subtle gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Item label
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Text(
                          'Item $index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 4,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ),

                      // Example video icon overlay (optional)
                      if (index % 4 == 0)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
