import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/state.dart';
import 'package:everylounge/presentation/widgets/inputs/code_text_field.dart';
import 'package:everylounge/presentation/widgets/shared/code_resend.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CodeStep extends StatelessWidget {
  final AddBankByPhoneNumberState state;
  final bool isKeyboardVisible;

  const CodeStep({
    Key? key,
    required this.state,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Мы выслали код на ваш телефон",
          style: context.textStyles.textLargeRegular(),
        ),
        Text(
          state.phoneController.text,
          style: context.textStyles.textLargeRegularLink(),
        ),
        const SizedBox(height: 32),
        CodeTextField(onCodeChanged: context.read<AddBankByPhoneNumberCubit>().onEnterCode),
        const SizedBox(height: 24),
        RegularButton(
          color: null,
          onPressed: context.read<AddBankByPhoneNumberCubit>().onContinuePressed2,
          label: const Text("Продолжить"),
          withoutElevation: true,
          canPress: state.canPressContinue2,
          isLoading: state.loading,
        ),
        const SizedBox(height: 24),
        CodeResendWidget(
          onResentPressed: context.read<AddBankByPhoneNumberCubit>().onResendCodePressed,
          onTimerEnd: context.read<AddBankByPhoneNumberCubit>().onTimerEnd,
          showTimer: state.showTimer,
          secondsLeft: state.timerSecondsLeft,
        ),
        SizedBox(height: isKeyboardVisible ? 0 : 24),
      ],
    );
  }
}
