import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IOSPickers extends StatelessWidget {
  const IOSPickers(this.firstDate, this.lastDate, {super.key, required this.onDateTimeChanged, required this.isTimePicker});

  final Function(DateTime value) onDateTimeChanged;
  final bool isTimePicker;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      height: size.height * 0.40,
      child: Column(
        children: [
          SizedBox(
            height: size.height / 3.5,
            child: CupertinoDatePicker(
                use24hFormat: true,
                minimumYear: firstDate.year,
                minimumDate: isTimePicker ? null : firstDate,
                maximumYear: lastDate.year,
                maximumDate: isTimePicker ? null : lastDate,
                mode: isTimePicker ? CupertinoDatePickerMode.time : CupertinoDatePickerMode.date,
                initialDateTime: firstDate,
                onDateTimeChanged: onDateTimeChanged),
          ),
          if (!isTimePicker) const Divider(color: Colors.grey),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RegularButton(
                color: context.colors.buttonDisabled,
                label: Text(
                  'Готово',
                  style: context.textStyles.textLargeBold(color: context.colors.buttonEnabled),
                ),
                onPressed: () => context.pop()),
          )
        ],
      ),
    );
  }
}
