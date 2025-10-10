import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgHandler extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Widget? fallbackWidget;
  final String? fallbackText;
  final VoidCallback? onError;
  final bool showErrorWidget;

  const SvgHandler({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.fallbackWidget,
    this.fallbackText,
    this.onError,
    this.showErrorWidget = true,
  });

  /// Factory constructor for icons
  const SvgHandler.icon({
    super.key,
    required this.assetPath,
    this.width = 24,
    this.height = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.fallbackWidget,
    this.fallbackText,
    this.onError,
    this.showErrorWidget = true,
  });

  /// Factory constructor for logos
  const SvgHandler.logo({
    super.key,
    required this.assetPath,
    this.width = 100,
    this.height = 100,
    this.color,
    this.fit = BoxFit.contain,
    this.fallbackWidget,
    this.fallbackText,
    this.onError,
    this.showErrorWidget = true,
  });

  /// Factory constructor for illustrations
  const SvgHandler.illustration({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.fallbackWidget,
    this.fallbackText,
    this.onError,
    this.showErrorWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _loadSvg(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        } else if (snapshot.hasError) {
          onError?.call();
          return _buildFallbackWidget();
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Future<Widget> _loadSvg() async {
    try {
      // Try to load the SVG
      return SizedBox(
        width: width,
        height: height,
        child: SvgPicture.asset(
          assetPath,
          width: width,
          height: height,
          color: color,
          fit: fit,
          placeholderBuilder: (context) => _buildLoadingWidget(),
        ),
      );
    } catch (e) {
      throw Exception('Failed to load SVG: $assetPath - Error: $e');
    }
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: width ?? 24,
      height: height ?? 24,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: SizedBox(
          width: (width ?? 24) * 0.3,
          height: (height ?? 24) * 0.3,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackWidget() {
    if (fallbackWidget != null) {
      return SizedBox(width: width, height: height, child: fallbackWidget!);
    }

    if (!showErrorWidget) {
      return const SizedBox.shrink();
    }

    return Container(
      width: width ?? 24,
      height: height ?? 24,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: fallbackText != null ? _buildTextFallback() : _buildIconFallback(),
    );
  }

  Widget _buildTextFallback() {
    return Center(
      child: Text(
        fallbackText!,
        style: TextStyle(
          color: color ?? Colors.grey[600],
          fontSize: (height ?? 24) * 0.3,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildIconFallback() {
    return Icon(
      Icons.image_not_supported_outlined,
      color: color ?? Colors.grey[400],
      size: (width ?? 24) * 0.6,
    );
  }
}
