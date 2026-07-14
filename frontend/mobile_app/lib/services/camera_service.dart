import 'dart:io';

class CameraService {
  Future<File> capturePhoto() async {
    final picturesDir = Directory(
      "/home/huzefa/Pictures/SHBox",
    );

    if (!await picturesDir.exists()) {
      await picturesDir.create(recursive: true);
    }

    final filePath =
        "${picturesDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

    final result = await Process.run(
      "rpicam-still",
      [
        "-o",
        filePath,
        "--nopreview",
        "-t",
        "800",
      ],
    );

    if (result.exitCode != 0) {
      throw Exception(result.stderr);
    }

    return File(filePath);
  }
}