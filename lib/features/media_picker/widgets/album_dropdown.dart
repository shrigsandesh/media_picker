import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class AlbumDropdown extends StatefulWidget {
  const AlbumDropdown(
      {super.key, required this.albums, required this.onChanged});

  final List<String> albums;
  final Function(String?) onChanged;

  @override
  State<AlbumDropdown> createState() => _AlbumDropdownState();
}

class _AlbumDropdownState extends State<AlbumDropdown> {
  bool dropdownOpen = false;
  late String dropdownValue = widget.albums[0];

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          children: [
            Icon(Icons.close),
          ],
        ),
      ]),
    );
    // return GestureDetector(
    //   onTap: () {
    //     setState(() {
    //       dropdownOpen = !dropdownOpen;
    //     });
    //   },
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(horizontal: 10),
    //     child: IntrinsicWidth(
    //       stepWidth: dropdownOpen ? null : 300,
    //       child: CustomDropdown<String>(
    //         items: widget.albums,
    //         initialItem: widget.albums[0],
    //         excludeSelected: false,
    //         onChanged: (v) {
    //           setState(() {
    //             dropdownOpen = false;
    //           });
    //         },
    //       ),
    //     ),
    //   ),
    // );
  }
}
