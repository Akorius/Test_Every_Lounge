import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/domain/entities/order/passenger.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class PassengerContent extends StatelessWidget {
  final List<Passenger> passengers;

  const PassengerContent({
    Key? key,
    required this.passengers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${passengers.first.firstName} ${passengers.first.lastName}",
          style: context.textStyles.textOrderDetailsLarge(),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(passengers.length > 1 ? "+${TextUtils.guestsText(passengers.length - 1)}" : "Без гостей")
      ],
    );
  }
}
