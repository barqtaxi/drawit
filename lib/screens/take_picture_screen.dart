import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:iconsax/iconsax.dart';
import 'display_picture_screen.dart';
import 'package:dotted_border/dotted_border.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('Take a picture'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(30),
                color: const Color(0xFF68C9F2),
                strokeWidth: 3,
                strokeCap: StrokeCap.round,
                dashPattern: const [18, 9],
                padding: const EdgeInsets.all(3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CameraPreview(_controller)),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(60.0),
        child: FloatingActionButton.extended(
          elevation: 0.0,
          backgroundColor: const Color(0xFF2CB1C9).withOpacity(0.9),
          onPressed: () async {
            try {
              await _initializeControllerFuture;
              final image = await _controller.takePicture();

              if (!mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              rethrow;
            }
          },
          icon: const Icon(
            Iconsax.camera4,
            color: const Color(0xFFF0F7F4)
          ),
          label: Text(
            'Capture Drawing',
            style: textTheme.titleSmall!.copyWith(
              color: const Color(0xFFF0F7F4)
            ),
          ),
        ),
      ),
    );
  }
}