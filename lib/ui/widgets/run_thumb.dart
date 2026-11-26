import 'dart:io';

import 'package:flutter/material.dart';

import 'brand_logo.dart';

/// Resolves a stored `runImageUrl` into a network URL, when one is needed.
typedef PhotoUrlResolver = String? Function(String? stored);

/// Builds the image widget for any of the three kinds of stored photo path:
///
///  * `assets/...`      — a bundled placeholder (offline demo rows)
///  * `http(s)://...`   — an absolute URL, or a Supabase object path that
///                        [resolver] turns into one
///  * anything else     — a local file written by the on-device photo store
///
/// Always falls back to the brand logo, so a missing photo or a dead network
/// never leaves a blank square.
class RunPhoto extends StatelessWidget {
  const RunPhoto({
    super.key,
    required this.path,
    required this.size,
    this.resolver,
    this.borderRadius = 10,
  });

  final String? path;
  final double size;
  final PhotoUrlResolver? resolver;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final fallback = SizedBox(
      width: size,
      height: size,
      child: Center(child: BrandLogo(width: size)),
    );

    final stored = path;
    if (stored == null || stored.isEmpty) return fallback;

    final Widget image;
    if (stored.startsWith('assets/')) {
      image = Image.asset(
        stored,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    } else if (stored.startsWith('http') ||
        (resolver != null && !stored.startsWith('/'))) {
      final url = resolver?.call(stored) ?? stored;
      if (url.isEmpty) return fallback;
      image = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
      );
    } else {
      image = Image.file(
        File(stored),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallback,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: size, height: size, child: image),
    );
  }
}
