import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/upgrade_flight/aero_companies.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/input_booking_data_area.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/upgrade_info_modal.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingDetailsArea extends StatelessWidget {
  final bool canGetBookingDetails;
  final AeroCompany currentCompany;

  const BookingDetailsArea(
    this.canGetBookingDetails,
    this.currentCompany, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  "Повысить класс перелёта",
                  maxLines: 1,
                  style: context.textStyles.h1(),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => showUpgradeInfoModal(context),
                  child: SvgPicture.asset(
                    AppImages.info,
                    color: context.colors.iconSelected,
                    width: 21,
                    height: 21,
                    fit: BoxFit.none,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 24),
            child: Column(
              children: [
                Text(
                  "Услуга доступна на рейсах компании:",
                  textAlign: TextAlign.center,
                  style: context.textStyles.textLargeRegular(),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  AeroCompany.aeroflot.name,
                  textAlign: TextAlign.center,
                  style: context.textStyles.textLargeRegular(color: context.colors.textBlue),
                ),
              ],
            ),
          ),
          const InputBookingDataArea(),
          const SizedBox(height: 16),
          RegularButton(
            label: const Text("Продолжить"),
            isLoading: context.read<SearchUpgradeFlightCubit>().state.isLoading,
            onPressed: () => {
              FocusScope.of(context).unfocus(),
              context.read<SearchUpgradeFlightCubit>().sendEventClick(eventName[upgradeServicesClick]!),
              context.read<SearchUpgradeFlightCubit>().onPressedContinue(),
            },
            withoutElevation: true,
            canPress: canGetBookingDetails,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
