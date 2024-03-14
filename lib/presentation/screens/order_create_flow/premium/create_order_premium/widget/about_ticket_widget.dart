import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class AboutTicketWidget extends StatelessWidget {
  const AboutTicketWidget({super.key, required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: context.colors.appBarText,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 48 - 16 - 8) / 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            title,
            maxLines: 1,
            style: context.textStyles.textSmallRegular(color: context.colors.hintText),
          ),
          AutoSizeText(
            text,
            maxLines: 1,
            style: context.textStyles.textLargeRegular(),
          ),
        ],
      ),
    );
  }
}
