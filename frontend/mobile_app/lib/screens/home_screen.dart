import 'dart:io';

import 'package:flutter/material.dart';
import '../services/signalr_service.dart';
import '../services/camera_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final camera = CameraService();
  final SignalRService signalRService = SignalRService();
  File? latestImage;

  bool busy = false;

  @override
  void initState() {
    super.initState();
    signalRService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SHBox Camera"),
      ),
      body: Column(
        children: [
          Expanded(
            child: latestImage == null
                ? const Center(
                    child: Text("No photo yet"),
                  )
                : Image.file(
                    latestImage!,
                    fit: BoxFit.contain,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(children: [FilledButton.icon(
              onPressed: busy
                  ? null
                  : () async {
                      setState(() {
                        busy = true;
                      });

                      final image =
                          await camera.capturePhoto();

                      setState(() {
                        latestImage = image;
                        busy = false;
                      });
                    },
              icon: const Icon(Icons.camera_alt),
              label: const Text("Capture"),
            ),FilledButton(
              onPressed: busy
                  ? null
                  : () async {
                      setState(() => busy = true);
                      try {
                        await signalRService.sendCommand("TakePhoto");
                      } catch (_) {
                        // ignore
                      } finally {
                        if (mounted) {
                          setState(() => busy = false);
                        }
                      }
                    },
              child: const Text(
                "Request Photo",
              ),
            )])
          )
        ],
      ),
    );
  }
}