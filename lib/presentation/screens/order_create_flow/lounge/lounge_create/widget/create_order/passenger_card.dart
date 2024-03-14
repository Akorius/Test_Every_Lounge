import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/create_order/name_info_modal.dart';
import 'package:everylounge/presentation/widgets/clipper/angle_radius_clipper.dart';
import 'package:everylounge/presentation/widgets/inputs/name_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class PassengerDecoration extends StatelessWidget {
  final Widget content;
  final bool isSecondCard;
  final bool isLastCard;

  const PassengerDecoration({
    Key? key,
    required this.content,
    required this.isSecondCard,
    required this.isLastCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: AnglesRadiusCutClipper(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(isSecondCard ? 0 : 24),
            bottom: Radius.circular(isLastCard ? 24 : 0),
          ),
          color: context.colors.textFieldBorderEnabled,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 20,
              color: context.colors.cardShadow2,
            )
          ],
        ),
        padding: EdgeInsets.only(top: isSecondCard ? 0 : 1, bottom: isLastCard ? 1 : 0, right: 1, left: 1),
        child: ClipPath(
          clipper: AnglesRadiusCutClipper(8),
          child: Builder(builder: (context) {
            final child = Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(isSecondCard ? 0 : 24),
                  bottom: Radius.circular(isLastCard ? 24 : 0),
                ),
                color: context.colors.cardBackground,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 20,
                    color: context.colors.cardShadow2,
                  )
                ],
              ),
              width: double.infinity,
              child: content,
            );
            return isLastCard
                ? child
                : DecoratedBox(
                    decoration: DottedDecoration(),
                    child: child,
                  );
          }),
        ),
      ),
    );
  }
}

//TODO обьединить с вторым PassengerContent
class PassengerContent extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final bool canEdit;
  final bool translit;

  final String? nameErrorText;
  final String? lastNameErrorText;

  const PassengerContent({
    Key? key,
    required this.nameController,
    required this.lastNameController,
    required this.nameErrorText,
    required this.lastNameErrorText,
    required this.canEdit,
    required this.translit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Пассажир",
                style: context.textStyles.h2(
                  color: context.colors.textOrderDetailsBlue,
                ),
              ),
              if (translit)
                GestureDetector(
                  onTap: () => showNameInfoModal(context),
                  child: SvgPicture.asset(
                    AppImages.info,
                    color: context.colors.textOrderDetailsBlue,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          NameTextField(
            controller: nameController,
            onChanged: (name) => context.read<LoungeCubit>().onPassengerNameChanged(name),
            onClear: canEdit ? () => context.read<LoungeCubit>().clearName() : null,
            enabled: canEdit,
            hint: "Имя",
            errorText: nameErrorText,
            translit: translit,
            allLettersCapitalization: translit,
          ),
          const SizedBox(height: 16),
          NameTextField(
            controller: lastNameController,
            onChanged: (lastName) => context.read<LoungeCubit>().onPassengerLastNameChanged(lastName),
            onClear: canEdit ? () => context.read<LoungeCubit>().clearLastName() : null,
            enabled: canEdit,
            hint: "Фамилия",
            errorText: lastNameErrorText,
            translit: translit,
            allLettersCapitalization: translit,
          ),
        ],
      ),
    );
  }
}
