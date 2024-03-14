import 'dart:io';

import 'package:flutter/foundation.dart';

class PlatformWrap {
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isWeb => kIsWeb;

  static bool get isAndroidOrIOS => isAndroid || isIOS;

  static bool get isIOSOrWeb => isIOS || isWeb;

  static bool get isAndroidOrWeb => isAndroid || isWeb;
}
