import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String text) onChanged;
  final String? hint;
  final String? bottomHintText;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;

  const PhoneTextField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.hint,
    this.bottomHintText,
    this.errorText,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      controller: controller,
      keyboardType: PlatformWrap.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.phone,
      onChanged: onChanged,
      bottomHintText: bottomHintText,
      errorText: errorText,
      inputFormatters: [
        ...?inputFormatters,
      ],
      maxLength: 16,
      hint: hint,
    );
  }
}
