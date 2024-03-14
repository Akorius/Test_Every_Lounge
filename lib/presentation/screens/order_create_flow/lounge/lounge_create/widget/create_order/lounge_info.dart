import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class LoungeInfo extends StatelessWidget {
  final Lounge lounge;
  late final String loungeName = lounge.name;

  LoungeInfo({
    Key? key,
    required this.lounge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 120),
        Text(
          loungeName,
          style: context.textStyles.h2(color: context.colors.appBarText),
        ),
      ],
    );
  }
}
