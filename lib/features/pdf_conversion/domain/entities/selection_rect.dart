import 'package:equatable/equatable.dart';

/// A user-selected viewport rectangle reported from WebView JavaScript.
class SelectionRect extends Equatable {
  const SelectionRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.dpr,
    required this.scrollX,
    required this.scrollY,
    required this.viewportWidth,
    required this.viewportHeight,
  });

  final double x;
  final double y;
  final double width;
  final double height;
  final double dpr;
  final double scrollX;
  final double scrollY;
  final double viewportWidth;
  final double viewportHeight;

  bool get hasValidSize => width > 0 && height > 0;

  bool get isWithinViewport =>
      x >= 0 &&
      y >= 0 &&
      (x + width) <= viewportWidth &&
      (y + height) <= viewportHeight;

  @override
  List<Object?> get props => [
        x,
        y,
        width,
        height,
        dpr,
        scrollX,
        scrollY,
        viewportWidth,
        viewportHeight,
      ];
}
