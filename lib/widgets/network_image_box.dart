import 'package:flutter/material.dart';

class NetworkImageBox extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final BorderRadius borderRadius;
  final BoxFit fit;

  const NetworkImageBox({
    super.key,
    required this.imageUrl,
    this.height,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: imageUrl.isEmpty
          ? _placeholder()
          : Image.network(
              imageUrl,
              height: height,
              width: double.infinity,
              fit: fit,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return _placeholder(loading: true);
              },
              errorBuilder: (context, error, stackTrace) => _placeholder(),
            ),
    );
  }

  Widget _placeholder({bool loading = false}) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFF2A2018),
      child: Center(
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white24),
              )
            : const Icon(Icons.image_outlined, size: 36, color: Colors.white12),
      ),
    );
  }
}
