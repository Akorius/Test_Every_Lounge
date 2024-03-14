import 'dart:async';

import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/state.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/widget/code_step.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/add_by_phone_number/widget/phone_step.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';

class AddBankByPhoneNumberModal extends StatefulWidget {
  static const path = "AddBankByPhoneNumberModal";

  const AddBankByPhoneNumberModal({
    Key? key,
  }) : super(key: key);

  @override
  createState() => _AddBankByPhoneNumberModalState();
}

class _AddBankByPhoneNumberModalState extends State<AddBankByPhoneNumberModal> {
  late StreamSubscription<bool> keyboardSubscription;

  var isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddBankByPhoneNumberCubit>();
    return StreamListener(
      stream: cubit.messageStream,
      onData: (message) {
        if (message == AddBankByPhoneNumberState.successAddProgram) {
          context.pop();
          context.pop();
          // context.pop(); /// выход на главный экран
          context.push(AppRoutes.successAddCardModal, extra: context.read<AddBankByPhoneNumberCubit>().bankCardType);
        } else {
          context.showSnackbar(message);
        }
      },
      child: BlocBuilder<AddBankByPhoneNumberCubit, AddBankByPhoneNumberState>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, right: 24, left: 24),
            decoration: BoxDecoration(
              color: context.colors.bottomSheetBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ModalTopElement(),
                const SizedBox(height: 48),
                Flexible(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Вход по номеру телефона",
                        style: context.textStyles.h1(),
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<AddBankByPhoneNumberCubit, AddBankByPhoneNumberState>(
                        builder: (context, state) {
                          switch (state.step) {
                            case AddBankByPhoneNumberStep.phone:
                              return PhoneStep(state: state, isKeyboardVisible: isKeyboardVisible);
                            case AddBankByPhoneNumberStep.code:
                              return CodeStep(state: state, isKeyboardVisible: isKeyboardVisible);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }
}
