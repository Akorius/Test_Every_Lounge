import 'package:flutter/material.dart';

class TicketClipperForTopCorner extends CustomClipper<Path> {
  double punchRadius;

  TicketClipperForTopCorner(this.punchRadius);

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(Rect.fromCircle(center: const Offset(0.0, 0), radius: punchRadius));
    path.addOval(Rect.fromCircle(center: Offset(size.width, 0), radius: punchRadius));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
