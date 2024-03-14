import 'package:everylounge/domain/entities/order/passenger.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_bottom.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_middle.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_top.dart';
import 'package:flutter/material.dart';

class ListPassengersInTicket extends StatelessWidget {
  const ListPassengersInTicket({
    Key? key,
    required this.passengers,
  }) : super(key: key);

  final List<Passenger> passengers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: passengers.length,
      itemBuilder: (context, i) {
        var passenger = passengers[i];
        var body = Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: context.colors.cardBackground,
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              border: passengers.length == 1 ? Border.all(color: context.colors.buttonDisabled) : null),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Пассажир ${i + 1}',
                    style: context.textStyles.textNormalRegular(color: context.colors.hintText),
                  ),
                  if (passengers[i].isChild) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 2,
                      height: 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.colors.hintText,
                      ),
                    ),
                    Text(
                      'Ребенок',
                      style: context.textStyles.textNormalRegular(color: context.colors.hintText),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${passenger.firstName} ${passenger.lastName}'.toUpperCase(),
                style: context.textStyles.h2(),
              ),
              passenger.rate?.value != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Wrap(
                        children: [
                          //TODO понадобиться позже при объединении с апгрейдами
                          // Text(
                          //   'Класс: ',
                          //   style: context.textStyles.textNormalRegular(color: context.colors.hintText),
                          // ),
                          // const SizedBox(width: 8),
                          // Text(
                          //   'Бизнес',
                          //   style: context.textStyles.textNormalRegular().copyWith(fontWeight: FontWeight.w500),
                          // ),
                          // const SizedBox(width: 24),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Стоимость: ',
                                style: context.textStyles.textNormalRegular(color: context.colors.hintText),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${passenger.rate?.value} ₽',
                                style: context.textStyles
                                    .textNormalRegular(ruble: true)
                                    .copyWith(fontWeight: FontWeight.w500)
                                    .copyWith(height: 1.2),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
        if (passengers.length == 1) {
          return body;
        }
        if (i == 0) {
          return TicketTop(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: body,
          );
        }
        if (i == passengers.length - 1) {
          return TicketBottom(
            isLounge: false,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: body,
          );
        } else {
          return TicketMiddle(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: body,
          );
        }
      },
    );
  }
}
