import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

import 'ticket_clipper_bottom_corner.dart';

class TicketTop extends StatelessWidget {
  const TicketTop({
    Key? key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.dashStrokeWidth,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final double? dashStrokeWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ClipPath(
            clipper: TicketClipperForBottomCorner(8),
            child: Container(
              padding: const EdgeInsets.only(left: 1, right: 1, top: 1),
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.lightDashBorder,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: ClipPath(
                clipper: TicketClipperForBottomCorner(8),
                child: Container(
                  height: height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor ?? context.colors.cardBackground,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                color: backgroundColor ?? context.colors.cardBackground,
                child: Container(
                  decoration: DottedDecoration(
                    shape: Shape.line,
                    strokeWidth: dashStrokeWidth ?? 1.0,
                    linePosition: LinePosition.bottom,
                    color: context.colors.lightDashBorder,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
