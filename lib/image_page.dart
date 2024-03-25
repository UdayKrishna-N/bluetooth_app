import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  String? path;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilledButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles(type: FileType.image);

                if (result != null) {
                  path = result.files.single.path!;
                }
              },
              child: const Text('Pick Images')),
          FilledButton(onPressed: () {}, child: const Text('Camera')),
        ],
      ),
    );
  }
}
