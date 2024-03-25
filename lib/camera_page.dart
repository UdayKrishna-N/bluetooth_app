import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class CamerPage extends ConsumerStatefulWidget {
  const CamerPage({super.key});

  @override
  ConsumerState<CamerPage> createState() => _CamerPageState();
}

class _CamerPageState extends ConsumerState<CamerPage> {
  late CameraController cameraController;
  List<CameraDescription> cameras = [];
  bool isLoading = true;
  var image = null;
  @override
  void initState() {
    super.initState();
    startCamera();
  }

  Future<void> startCamera() async {
    var cameras = await availableCameras();

    cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      isLoading = false;
      setState(() {});
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: image == null
          ? isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: CameraPreview(cameraController)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () async {
                            Directory dir =
                                await getApplicationDocumentsDirectory();
                            cameraController.takePicture().then((xFile) {
                              image = File(xFile.path);
                              setState(() {});
                              // xFile.saveTo(dir.path);
                            });
                          },
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.camera,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50, right: 20),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: InkWell(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              image = File(result.files.single.path!);
                              setState(() {});
                            }
                          },
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 3),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
          : Stack(
              children: [
                Center(
                  child: Image.file(image),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 15),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          image = null;
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
