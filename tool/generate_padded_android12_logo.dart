import 'dart:io';
import 'package:image/image.dart' as img;

// Generates a padded square PNG for Android 12 splash icon to avoid circular cropping.
// Input:  assets/icons/Logo.png
// Output: assets/icons/Logo_android12.png (square with transparent padding)
// Padding: 18% of the canvas size around the logo

Future<void> main() async {
  final inputPath = 'assets/icons/Logo.png';
  final outputPath = 'assets/icons/Logo_android12.png';

  if (!File(inputPath).existsSync()) {
    stderr.writeln('Input logo not found at $inputPath');
    exit(1);
  }

  final bytes = await File(inputPath).readAsBytes();
  final original = img.decodeImage(bytes);
  if (original == null) {
    stderr.writeln('Failed to decode input image. Ensure it is a valid PNG.');
    exit(1);
  }

  // Define output canvas size (Android 12 recommends large asset; 960x960 works well)
  const canvasSize = 960;
  final padding = (canvasSize * 0.18).round(); // 18% padding on each side
  final maxLogoSize = canvasSize - padding * 2;

  // Compute scaled size preserving aspect ratio
  final scale = (original.width > original.height)
      ? maxLogoSize / original.width
      : maxLogoSize / original.height;
  final newW = (original.width * scale).round();
  final newH = (original.height * scale).round();

  final resized = img.copyResize(original, width: newW, height: newH, interpolation: img.Interpolation.linear);

  // Create transparent canvas
  final canvas = img.Image(width: canvasSize, height: canvasSize);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));

  // Paste resized logo centered
  final x = ((canvasSize - newW) / 2).round();
  final y = ((canvasSize - newH) / 2).round();
  img.compositeImage(canvas, resized, dstX: x, dstY: y);

  final outBytes = img.encodePng(canvas);
  await File(outputPath).writeAsBytes(outBytes);
  stdout.writeln('Generated padded Android 12 logo at $outputPath');
}
