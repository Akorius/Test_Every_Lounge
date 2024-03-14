import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialSignInButton extends RegularButtonNegative {
  final String icon;
  final String text;

  SocialSignInButton({
    required this.icon,
    required this.text,
    super.key,
    required super.onPressed,
    super.canPress,
    super.isLoading,
    super.minWidth,
  }) : super(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 24,
              ),
              if (text.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(text),
              ]
            ],
          ),
          height: 48,
        );
}
