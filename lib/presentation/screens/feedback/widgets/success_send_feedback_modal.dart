import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessSendFeedbackModal extends StatelessWidget {
  static const path = "successSendFeedbackModal";

  const SuccessSendFeedbackModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: context.colors.buttonNegative,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          )),
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 24 + (PlatformWrap.isIOS ? 21 : 0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ModalTopElement(),
          const SizedBox(height: 24),
          Image.asset(
            AppImages.success,
            height: 200,
          ),
          const SizedBox(height: 24),
          Text(
            "Спасибо,\nваша заявка принята!",
            textAlign: TextAlign.center,
            style: context.textStyles.h2(),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              height: 54,
              width: MediaQuery.of(context).size.width,
              child: RegularButton(
                isOutline: true,
                label: Text(
                  'Понятно',
                  style: context.textStyles.negativeButtonText(),
                ),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
