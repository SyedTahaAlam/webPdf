// lib/core/widgets/loading_shimmer.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webpdf/core/theme/app_theme_extension.dart';

/// Shimmer skeleton placeholder for async content.
class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    this.width = double.infinity,
    this.height = 80,
    this.borderRadius = 8,
    super.key,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Shimmer.fromColors(
      baseColor: ext.shimmerBase,
      highlightColor: ext.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: ext.shimmerBase,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// A list of shimmer cards used while loading history.
class ShimmerList extends StatelessWidget {
  const ShimmerList({this.count = 5, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const LoadingShimmer(height: 88),
    );
  }
}
