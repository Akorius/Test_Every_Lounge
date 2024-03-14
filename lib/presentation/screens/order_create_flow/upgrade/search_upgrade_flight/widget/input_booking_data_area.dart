import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/cubit.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'find_booking_code_info.dart';

class InputBookingDataArea extends StatefulWidget {
  const InputBookingDataArea({
    Key? key,
  }) : super(key: key);

  @override
  State<InputBookingDataArea> createState() => _InputBookingDataAreaState();
}

class _InputBookingDataAreaState extends State<InputBookingDataArea> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextField(
          onTap: () => context.read<SearchUpgradeFlightCubit>().disableNotification(),
          onSubmitted: (_) => {},
          onChanged: (_) => {
            setState(
              () => context.read<SearchUpgradeFlightCubit>().validateBookingData(),
            )
          },
          maxLength: 50,
          controller: context.read<SearchUpgradeFlightCubit>().surnameController,
          keyboardType: TextInputType.text,
          suffixIcon: context.read<SearchUpgradeFlightCubit>().surnameController.text.isEmpty
              ? null
              : GestureDetector(
                  onTap: () => setState(() => context.read<SearchUpgradeFlightCubit>().onClearSurname()),
                  child: SvgPicture.asset(
                    AppImages.clearIcon,
                    width: 21,
                    height: 21,
                    fit: BoxFit.none,
                  ),
                ),
          errorText: null,
          hint: "Фамилия",
          enabled: true,
        ),
        const SizedBox(height: 16),
        DefaultTextField(
          onTap: () => context.read<SearchUpgradeFlightCubit>().disableNotification(),
          onSubmitted: (_) => {},
          onChanged: (_) => setState(
            () => context.read<SearchUpgradeFlightCubit>().validateBookingData(),
          ),
          maxLength: 6,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          controller: context.read<SearchUpgradeFlightCubit>().codeController,
          keyboardType: TextInputType.text,
          errorText: null,
          hint: "Код бронирования (PNR)",
          enabled: true,
          suffixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              context.read<SearchUpgradeFlightCubit>().codeController.text.isNotEmpty
                  ? GestureDetector(
                      onTap: () => setState(() => context.read<SearchUpgradeFlightCubit>().onClearCode()),
                      child: SvgPicture.asset(
                        AppImages.clearIcon,
                        width: 21,
                        height: 21,
                        fit: BoxFit.none,
                      ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => showFindBookingCodeInfoModal(context),
                child: SvgPicture.asset(
                  AppImages.info,
                  color: context.colors.iconSelected,
                  width: 21,
                  height: 21,
                  fit: BoxFit.none,
                ),
              ),
              const SizedBox(width: 10)
            ],
          ),
        ),
      ],
    );
  }
}
