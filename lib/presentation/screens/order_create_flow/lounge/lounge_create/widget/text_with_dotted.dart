import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class TextWithDottedBorder extends StatelessWidget {
  const TextWithDottedBorder(
    this.text, {
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 2,
        ),
        decoration: DottedDecoration(
          shape: Shape.line,
          linePosition: LinePosition.bottom,
          color: context.colors.textBlue,
        ),
        child: Text(
          text,
          style: context.textStyles.textLargeBold(color: context.colors.textBlue),
        ),
      ),
    );
  }
}
