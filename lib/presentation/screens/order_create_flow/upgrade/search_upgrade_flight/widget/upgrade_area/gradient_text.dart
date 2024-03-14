import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final String text;

  const GradientText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => const LinearGradient(colors: [
          Color(0xFFFFFFFF),
          Color(0xFFA6BAFF),
          Color(0xFFC0A6FF),
          Color(0xFFC6BAE1),
        ]).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Text(
          textAlign: TextAlign.center,
          text,
          style: context.textStyles
              .h1(color: context.colors.textLight, ruble: true)
              .copyWith(fontSize: MediaQuery.of(context).size.width < 480 ? 16 : null),
        ),
      ),
    );
  }
}
