import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

import 'ticket_clipper_bottom_corner.dart';
import 'ticket_clipper_top_corner.dart';

class TicketMiddle extends StatelessWidget {
  const TicketMiddle({
    Key? key,
    required this.child,
    this.height,
    this.dashStrokeWidth,
    this.withBorder = true,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final double? height;
  final double? dashStrokeWidth;
  final bool withBorder;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          withBorder
              ? ClipPath(
                  clipper: TicketClipperForTopCorner(8),
                  child: ClipPath(
                    clipper: TicketClipperForBottomCorner(8),
                    child: Container(
                      padding: const EdgeInsets.only(left: 1, right: 1),
                      width: double.infinity,
                      height: height,
                      decoration: BoxDecoration(
                        color: context.colors.lightDashBorder,
                      ),
                      child: ClipPath(
                        clipper: TicketClipperForTopCorner(8),
                        child: ClipPath(
                          clipper: TicketClipperForBottomCorner(8),
                          child: Container(
                            width: double.infinity,
                            height: height,
                            decoration: BoxDecoration(
                              color: context.colors.cardBackground,
                            ),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : ClipPath(
                  clipper: TicketClipperForTopCorner(8),
                  child: ClipPath(
                    clipper: TicketClipperForBottomCorner(8),
                    child: Container(
                      width: double.infinity,
                      height: height,
                      decoration: BoxDecoration(
                        color: context.colors.cardBackground,
                      ),
                      child: child,
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: double.infinity,
              child: Container(
                color: context.colors.cardBackground,
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
          ),
        ],
      ),
    );
  }
}
