import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedError extends StatelessWidget {
  const AnimatedError(
    this.errorMessage, {
    super.key,
  });

  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: (errorMessage?.isNotEmpty == true) ? 110 : 0,
      width: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width,
          color: context.colors.buttonDisabled,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  errorMessage == errClassUpgradeDisallow
                      ? 'Невозможно повысить класс обслуживания для данного рейса.'
                      : 'В доступных авиакомпаниях бронирование не найдено. Пожалуйста, проверьте корректность введённых данных.',
                  style: context.textStyles.textNormalRegular(color: context.colors.textDefault),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  context.read<SearchUpgradeFlightCubit>().disableNotification();
                },
                child: SvgPicture.asset(
                  AppImages.clearText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
