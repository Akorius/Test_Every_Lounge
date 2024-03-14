import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/domain/entities/lounge/flight_direction.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class LoungeCustomSwitcher extends StatefulWidget {
  final Function(int index) onSelect;

  const LoungeCustomSwitcher({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<LoungeCustomSwitcher> createState() => _LoungeCustomSwitcherState();
}

class _LoungeCustomSwitcherState extends State<LoungeCustomSwitcher> {
  int switcherIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.colors.switcherColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(18.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LoungeDestinationSwitcherItem(
            text: FlightDirection.anyTextSwitcher,
            isActive: switcherIndex == 0,
            onTap: () => onTap(0),
            flex: 1,
          ),
          LoungeDestinationSwitcherItem(
            text: FlightDirection.internTextSwitcher,
            isActive: switcherIndex == 1,
            onTap: () => onTap(1),
            flex: 3,
          ),
          LoungeDestinationSwitcherItem(
            text: FlightDirection.domesticTextSwitcher,
            isActive: switcherIndex == 2,
            onTap: () => onTap(2),
            flex: 2,
          ),
        ],
      ),
    );
  }

  onTap(int index) {
    setState(() {
      switcherIndex = index;
      widget.onSelect(index);
    });
  }
}

class LoungeDestinationSwitcherItem extends StatelessWidget {
  final String text;
  final bool isActive;
  final Function onTap;
  final int flex;

  const LoungeDestinationSwitcherItem({
    Key? key,
    required this.text,
    required this.isActive,
    required this.onTap,
    required this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: isActive
              ? const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                )
              : null,
          child: AutoSizeText(
            text,
            maxLines: 1,
            minFontSize: 12,
            textAlign: TextAlign.center,
            style: context.textStyles.textNormalRegular(color: context.colors.textBlue),
          ),
        ),
      ),
    );
  }
}
