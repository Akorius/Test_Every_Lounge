import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

import 'bottom_menu_item.dart';

class LoginBottomMenu extends StatelessWidget {
  final Function(int index) onItemSelected;
  final int selectedIndex;

  const LoginBottomMenu({
    Key? key,
    required this.onItemSelected,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 75, right: 75),
      height: 70,
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomMenuItem(
            selected: selectedIndex == 0,
            text: 'Главный',
            icon: AppImages.home,
            onPressed: () => onItemSelected(0),
          ),
          BottomMenuItem(
            selected: selectedIndex == 1,
            text: 'Информация',
            icon: AppImages.infoBottom,
            onPressed: () {
              onItemSelected(1);
            },
          ),
        ],
      ),
    );
  }
}
