import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

extension LinkExtension on String {
  Future<void> onLinkPressed(BuildContext context) async {
    try {
      if (!await launchUrl(Uri.parse(this), mode: LaunchMode.externalApplication)) {
        context.showSnackbar("Невозможно открыть ссылку: $this");
      }
    } catch (e) {
      context.showSnackbar("Невозможно открыть ссылку: $this");
    }
  }
}
