import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/add_passenger_button.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/passenger_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassengersStep extends StatelessWidget {
  const PassengersStep({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderPremiumCubit, CreateOrderPremiumState>(
      builder: (context, state) => Container(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Данные пассажиров",
              style: context.textStyles.h1(color: context.colors.textBlue),
            ),
            if (state.isTranslitNames) ...[
              const SizedBox(height: 8),
              Text(
                "Имя автоматически указывается латиницей."
                "\nПо правилам авиации расхождение с данными паспорта может составлять до 4 знаков.",
                style: context.textStyles.textSmallRegularGrey(),
              )
            ],
            const SizedBox(height: 24),
            ...state.passengers
                .asMap()
                .entries
                .map<Widget>(
                  (e) => PassengerContent(
                    passengerNumber: e.key + 1,
                    nameController: state.nameControllers[e.key]
                      ..text = e.value.firstName
                      ..selection = TextSelection.fromPosition(TextPosition(offset: e.value.firstName.length)),
                    lastNameController: state.lastNameControllers[e.key]
                      ..text = e.value.lastName
                      ..selection = TextSelection.fromPosition(TextPosition(offset: e.value.lastName.length)),
                    nameErrorText: state.nameErrors[e.key],
                    lastNameErrorText: state.lastNameErrors[e.key],
                    canEdit: true,
                    isTranslit: state.isTranslitNames,
                    isChild: e.value.child,
                  ),
                )
                .toList(),
            const SizedBox(height: 16),
            AddPassengerButton(onPressed: context.read<CreateOrderPremiumCubit>().onAddPassengerPressed),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
