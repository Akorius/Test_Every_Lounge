import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext buildContext) {
      return Center(
        child: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: const AppCircularProgressIndicator(),
        ),
      );
    },
  );
}
