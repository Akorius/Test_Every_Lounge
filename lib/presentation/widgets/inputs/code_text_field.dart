import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeTextField extends StatelessWidget {
  final Function(String text) onCodeChanged;
  final Function(String text)? onCodeCompleted;
  final bool enabled;

  const CodeTextField({
    Key? key,
    required this.onCodeChanged,
    this.onCodeCompleted,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      enabled: enabled,
      appContext: context,
      length: 4,
      mainAxisAlignment: MainAxisAlignment.center,
      pinTheme: PinTheme.defaults(
        activeColor: context.colors.textFieldBorderEnabled,
        selectedColor: context.colors.textFieldBorderFocused,
        inactiveColor: context.colors.textFieldBorderEnabled,
        errorBorderColor: context.colors.textFieldError,
        fieldHeight: 50,
        fieldWidth: 42,
        borderWidth: 1,
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 7.5),
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(8),
      ),
      animationType: AnimationType.scale,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"\d"))],
      onChanged: onCodeChanged,
      onCompleted: onCodeCompleted,
    );
  }
}
