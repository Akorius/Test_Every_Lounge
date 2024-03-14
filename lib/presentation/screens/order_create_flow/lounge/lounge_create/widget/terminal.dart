import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class Terminal extends StatelessWidget {
  const Terminal(
    this.terminal, {
    super.key,
  });

  final String terminal;

  @override
  Widget build(BuildContext context) {
    return terminal.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: context.colors.buttonDisabled,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                terminal,
                style: context.textStyles.textLargeRegular(color: context.colors.textBlue).copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
