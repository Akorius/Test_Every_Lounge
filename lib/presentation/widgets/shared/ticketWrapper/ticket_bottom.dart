import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

import 'ticket_clipper_top_corner.dart';

class TicketBottom extends StatelessWidget {
  const TicketBottom({
    Key? key,
    required this.child,
    this.height,
    this.withBorder = true,
    this.padding,
    required this.isLounge,
  }) : super(key: key);

  final Widget child;
  final double? height;
  final bool isLounge;
  final bool withBorder;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: ClipPath(
        clipper: TicketClipperForTopCorner(8),
        child: withBorder
            ? Container(
                padding: const EdgeInsets.only(left: 1, right: 1, bottom: 1),
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                  color: context.colors.lightDashBorder,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: ClipPath(
                  clipper: TicketClipperForTopCorner(8),
                  child: Container(
                      width: double.infinity,
                      height: height,
                      decoration: BoxDecoration(
                        color: context.colors.cardBackground,
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: child),
                ),
              )
            : Container(
                width: double.infinity,
                height: height,
                decoration: BoxDecoration(
                  color: context.colors.cardBackground,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: child),
      ),
    );
  }
}
