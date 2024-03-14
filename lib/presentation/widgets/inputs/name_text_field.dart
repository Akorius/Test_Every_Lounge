import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/input_formatters/all_letters_capitalization.dart';
import 'package:everylounge/presentation/common/input_formatters/first_letter_capitalization.dart';
import 'package:everylounge/presentation/common/input_formatters/only_en_letters.dart';
import 'package:everylounge/presentation/common/input_formatters/only_letters.dart';
import 'package:everylounge/presentation/common/input_formatters/only_one_word.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NameTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final Function(String text) onChanged;
  final Function(String text)? onSubmitted;
  final Function()? onClear;
  final bool enabled;
  final bool translit;
  final bool allLettersCapitalization;

  const NameTextField({
    Key? key,
    required this.controller,
    this.errorText,
    required this.onChanged,
    this.onClear,
    this.onSubmitted,
    required this.enabled,
    required this.hint,
    required this.translit,
    required this.allLettersCapitalization,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      maxLength: 50,
      controller: controller,
      keyboardType: TextInputType.name,
      errorText: errorText,
      hint: hint,
      enabled: enabled,
      suffixIcon: controller.text.isNotEmpty && onClear != null
          ? GestureDetector(
              onTap: () => onClear?.call(),
              child: SvgPicture.asset(
                AppImages.clearIcon,
                width: 21,
                height: 21,
                fit: BoxFit.none,
              ),
            )
          : null,
      inputFormatters: [
        OnlyOneWordTextFormatter(),
        if (translit) OnlyEnLettersTextFormatter() else OnlyLettersTextFormatter(),
        if (allLettersCapitalization) AllLettersCapitalizationTextFormatter() else FirstLetterUpperCaseTextFormatter(),
      ],
    );
  }
}
