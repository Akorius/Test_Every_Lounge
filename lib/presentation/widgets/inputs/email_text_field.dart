import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;
  final String? errorText;
  final Function(String text) onChanged;
  final Function(String text)? onSubmitted;
  final Function()? onClear;
  final bool enabled;

  const EmailTextField({
    super.key,
    required this.emailController,
    required this.errorText,
    required this.onChanged,
    required this.onClear,
    this.onSubmitted,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextField(
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      maxLength: 50,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      errorText: errorText,
      hint: "Ваш e-mail",
      enabled: enabled,
      suffixIcon: emailController.text.isNotEmpty
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
    );
  }
}
