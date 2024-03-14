import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/cubit.dart';
import 'package:everylounge/presentation/widgets/inputs/name_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'children_switcher.dart';

class PassengerContent extends StatelessWidget {
  final int passengerNumber;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final bool canEdit;
  final bool isTranslit;
  final bool isChild;

  final String? nameErrorText;
  final String? lastNameErrorText;

  const PassengerContent({
    Key? key,
    required this.passengerNumber,
    required this.nameController,
    required this.lastNameController,
    required this.nameErrorText,
    required this.lastNameErrorText,
    required this.canEdit,
    required this.isTranslit,
    required this.isChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<CreateOrderPremiumCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (passengerNumber > 1) ...[
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: context.colors.lightDashBorder,
          ),
          const SizedBox(height: 24),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Пассажир $passengerNumber",
              style: context.textStyles.h2(
                color: context.colors.textOrderDetailsBlue,
              ),
            ),
            if (passengerNumber > 1)
              GestureDetector(
                onTap: () => bloc.onRemovePassengerPressed(passengerNumber - 1),
                child: Text(
                  "Удалить",
                  style: context.textStyles.textNormalRegularGrey(),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        NameTextField(
          controller: nameController,
          onChanged: (name) => bloc.onPassengerNameChanged(name, passengerNumber - 1),
          enabled: canEdit,
          hint: "Имя",
          errorText: nameErrorText,
          translit: isTranslit,
          allLettersCapitalization: isTranslit,
        ),
        const SizedBox(height: 8),
        NameTextField(
          controller: lastNameController,
          onChanged: (lastName) => bloc.onPassengerLastNameChanged(lastName, passengerNumber - 1),
          enabled: canEdit,
          hint: "Фамилия",
          errorText: lastNameErrorText,
          translit: isTranslit,
          allLettersCapitalization: isTranslit,
        ),
        const SizedBox(height: 8),
        if (passengerNumber != 1) ...[
          ChildrenDateSwitcher(
            onToggle: bloc.onChildrenToggle,
            enabled: isChild,
            index: passengerNumber - 1,
            birthDate: bloc.state.passengers[passengerNumber - 1].childBirthDate,
            onDateSelected: bloc.onChildrenDateSelect,
          ),
          const SizedBox(height: 0),
        ],
      ],
    );
  }
}
