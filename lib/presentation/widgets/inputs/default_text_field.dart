import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool enabled;
  final Function(String text) onChanged;
  final Function(String text)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? capitalization;
  final String? hint;
  final String? errorText;
  final String? bottomHintText;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextStyle? style;
  final int? maxLines;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final Function()? onEditingComplete;
  final Function()? onTap;

  const DefaultTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    required this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.bottomHintText,
    this.capitalization,
    this.maxLength,
    this.maxLengthEnforcement,
    this.inputFormatters,
    this.hint,
    this.enabled = true,
    this.style,
    this.maxLines,
    this.suffixIconConstraints,
    this.suffixIcon,
    this.onEditingComplete,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onTap: () => onTap?.call(),
          cursorHeight: 22,
          cursorWidth: 1.5,
          onSubmitted: onSubmitted,
          inputFormatters: inputFormatters,
          textCapitalization: capitalization ?? TextCapitalization.none,
          onChanged: onChanged,
          maxLength: maxLength,
          maxLengthEnforcement: maxLengthEnforcement ?? MaxLengthEnforcement.truncateAfterCompositionEnds,
          cursorColor: context.colors.buttonEnabled,
          style: style ??
              context.textStyles
                  .textLargeRegular(color: enabled ? context.colors.textDefault : context.colors.textDefault.withOpacity(0.6)),
          controller: controller,
          maxLines: maxLines ?? 1,
          keyboardType: keyboardType,
          enableSuggestions: false,
          autocorrect: false,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            counterText: "",
            hintText: hint,
            hintStyle: context.textStyles.textFieldHint,
            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorText == null ? context.colors.textFieldBorderEnabled : context.colors.textFieldError,
              ),
              borderRadius: BorderRadius.circular(8),
              gapPadding: 6,
            ),
            suffixIconConstraints: suffixIconConstraints,
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorText == null ? context.colors.textFieldBorderFocused : context.colors.textFieldError,
              ),
              borderRadius: BorderRadius.circular(8),
              gapPadding: 6,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: errorText == null ? context.colors.textFieldBorderEnabled : context.colors.textFieldError,
              ),
              borderRadius: BorderRadius.circular(8),
              gapPadding: 6,
            ),
          ),
          enabled: enabled,
        ),
        if (bottomHintText != null || errorText != null) ...[
          const SizedBox(height: 2),
          Text(
            errorText != null ? errorText! : bottomHintText!,
            style: errorText != null ? context.textStyles.textFieldError : context.textStyles.textFieldBottomHint,
          )
        ]
      ],
    );
  }
}
