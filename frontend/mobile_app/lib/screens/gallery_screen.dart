import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../models/photo.dart';
import '../services/photo_service.dart';
import '../services/signalr_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final SignalRService signalR = SignalRService();
  final PhotoService service = PhotoService();
  List<Photo> photos = [];

  @override
  void initState() {
    super.initState();
    loadPhotos();
    setupSignalR();
  }

  Future<void> setupSignalR() async {
    signalR.photos.listen((_) {
      loadPhotos();
    });

    await signalR.connect();
  }

  Future<void> loadPhotos() async {
    final result = await service.getPhotos();
    if (!mounted) return;
    setState(() {
      photos = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SHBox Memories ❤️")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return Card(
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    AppConfig.resolveStorageUrl(
                      AppConfig.readServerUrl(AppConfig.defaultServerUrl),
                      photo.fileName,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Text(photo.caption),
              ],
            ),
          );
        },
      ),
    );
  }
}
