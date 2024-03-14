import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class UnorderedListItem extends StatelessWidget {
  const UnorderedListItem(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(" • ", style: context.textStyles.textNormalRegular()),
        Expanded(
          child: Text(text, style: context.textStyles.textNormalRegular()),
        ),
      ],
    );
  }
}
