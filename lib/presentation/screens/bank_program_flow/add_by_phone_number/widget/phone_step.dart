import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/state.dart';
import 'package:everylounge/presentation/widgets/inputs/phone_text_field.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneStep extends StatelessWidget {
  final AddBankByPhoneNumberState state;
  final bool isKeyboardVisible;

  const PhoneStep({
    Key? key,
    required this.state,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Введите номер телефона",
          style: context.textStyles.textLargeRegular(),
        ),
        const SizedBox(height: 48),
        PhoneTextField(
          controller: state.phoneController,
          onChanged: context.read<AddBankByPhoneNumberCubit>().onEnterPhone,
          bottomHintText: "на этот номер придёт код",
          hint: "+7",
          errorText: state.phoneNumberError,
        ),
        const SizedBox(height: 24),
        RegularButton(
          color: null,
          onPressed: () {
            context.read<AddBankByPhoneNumberCubit>().onContinuePressed();
          },
          label: const Text("Продолжить"),
          withoutElevation: true,
          canPress: state.canPressContinue,
          isLoading: state.loading,
        ),
        SizedBox(height: isKeyboardVisible ? 0 : 70),
      ],
    );
  }
}
