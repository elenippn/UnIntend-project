import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final placeholder = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: borderRadius,
      ),
      child: const Icon(
        Icons.image,
        color: Color(0xFFBDBDBD),
      ),
    );

    if (url == null || url.trim().isEmpty) {
      return placeholder;
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, _) => placeholder,
        errorWidget: (context, _, __) => placeholder,
      ),
    );
  }
}

class AppProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final IconData fallbackIcon;

  const AppProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.size,
    this.fallbackIcon = Icons.person,
  });

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;

    Widget fallback() {
      return Center(
        child: Icon(
          fallbackIcon,
          size: size * 0.5,
          color: const Color(0xFF1B5E20),
        ),
      );
    }

    if (url == null || url.trim().isEmpty) {
      return fallback();
    }

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, _) => fallback(),
        errorWidget: (context, _, __) => fallback(),
      ),
    );
  }
}
