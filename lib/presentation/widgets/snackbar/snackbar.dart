import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

extension SnackBarExt on BuildContext {
  showSnackbar(String message) {
    AnimatedSnackBar(
      duration: seconds(6),
      builder: ((context) {
        return Container(
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.textNormalRegular(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      }),
    ).show(this);
  }
}

extension TopSnackBarExt on BuildContext {
  showTopSnackbar(String message) {
    showTopSnackBar(
        Overlay.of(this),
        Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.textNormalRegular(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        persistent: false,
        animationDuration: seconds(1),
        displayDuration: seconds(3),
        reverseAnimationDuration: seconds(1),
        curve: Curves.linearToEaseOut);
  }
}
