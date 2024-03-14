import 'package:everylounge/domain/entities/upgrade_flight/passenger.dart';
import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/create_upgrade_order/state.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListPassengersInOrder extends StatelessWidget {
  const ListPassengersInOrder({
    Key? key,
    this.addToCard,
    this.segment,
    required this.state,
  }) : super(key: key);

  final Function(PassengerFU)? addToCard;
  final Segment? segment;
  final CreateUpgradeOrderState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...state.searchedBooking.passengers.map(
          (passenger) {
            return Container(
              margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (passenger.paxType == PaxType.child)
                    Text(
                      'Ребенок',
                      style: context.textStyles.textNormalRegularGrey(),
                    ),
                  Text(
                    '${passenger.firstName} ${passenger.lastName}'.toUpperCase(),
                    style: context.textStyles.h2(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Эконом',
                      style: context.textStyles.textNormalRegularGrey(),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: state.ticketToCardMap[segment] != null && state.ticketToCardMap[segment]!.contains(passenger)
                        ? RegularButtonNegative(
                            onPressed: () => context.read<CreateUpgradeOrderCubit>().addPassToCard(segment!, passenger),
                            height: 48,
                            minWidth: MediaQuery.of(context).size.width,
                            backgroundColor: context.colors.appBarBackArrowBorder,
                            colorBorder: context.colors.appBarBackArrowBorder,
                            overlayColor: context.colors.appBarBackArrowBorder,
                            child: Text(
                              'Отменить выбор',
                              style: context.textStyles.textSmallBold(color: context.colors.textBlue),
                            ),
                          )
                        : RegularButtonNegative(
                            height: 48,
                            minWidth: MediaQuery.of(context).size.width,
                            colorBorder: context.colors.buttonInfoBorderBlue,
                            overlayColor: context.colors.textLight,
                            onPressed: () => context.read<CreateUpgradeOrderCubit>().addPassToCard(segment!, passenger),
                            child: Text(
                              'Повысить до бизнеса',
                              style: context.textStyles.textSmallBold(color: context.colors.textBlue),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
