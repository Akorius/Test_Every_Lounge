import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/screens/profile/cubit.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileBottomBar extends StatelessWidget {
  const ProfileBottomBar({
    super.key,
    required this.hideBanks,
    required this.isCardAttaching,
  });

  final bool hideBanks;
  final bool isCardAttaching;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: PlatformWrap.isIOS ? 21 : 16),
      child: Wrap(
        children: [
          if (!PlatformWrap.isWeb)
            RegularButton(
              label: const Text("Добавить способ оплаты"),
              onPressed: () {
                context.read<ProfileCubit>().sendEventClick(eventName[addPaymentBackCardClick]!);
                hideBanks
                    ? context.read<ProfileCubit>().attachCardCubit.openAttachCardScreen()
                    : context.push(AppRoutes.selectPaymentMethodModal);
              },
              canPress: !isCardAttaching,
              isLoading: isCardAttaching,
            ),
        ],
      ),
    );
  }
}
