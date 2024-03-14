import 'package:everylounge/domain/entities/order/passenger.dart';
import 'package:everylounge/domain/entities/upgrade_flight/segment.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_bottom.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_middle.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_top.dart';
import 'package:flutter/material.dart';

//TODO похоже на дубликат от
//import 'package:everylounge/domain/entities/order/premium/premium_passengers.dart';
// нужно объединить
class ListPassengersInTicket extends StatelessWidget {
  const ListPassengersInTicket({
    Key? key,
    required this.passengers,
    this.segment,
  }) : super(key: key);

  final List<Passenger> passengers;
  final Segment? segment;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
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
              border: passengers.length == 1 ? Border.all(color: context.colors.lightDashBorder) : null),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Пассажир ${i + 1}',
                style: context.textStyles.textNormalRegular(color: context.colors.hintText),
              ),
              const SizedBox(height: 4),
              Text(
                '${passenger.firstName} ${passenger.lastName}'.toUpperCase(),
                style: context.textStyles.h2(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Класс: ',
                    style: context.textStyles.textNormalRegular(color: context.colors.hintText),
                  ),
                  Text(
                    'Повышен до Бизнес',
                    style: context.textStyles.textNormalRegular(color: context.colors.textDefault),
                  ),
                ],
              ),
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
