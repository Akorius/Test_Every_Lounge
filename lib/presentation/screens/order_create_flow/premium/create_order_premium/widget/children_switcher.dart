import 'package:duration/duration.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/widgets/inputs/date_picker_field.dart';
import 'package:everylounge/presentation/widgets/tappable/switch.dart';
import 'package:flutter/material.dart';

class ChildrenDateSwitcher extends StatelessWidget {
  final bool enabled;
  final int index;
  final DateTime? birthDate;
  final Function(int, bool) onToggle;
  final Function(int, DateTime) onDateSelected;

  const ChildrenDateSwitcher({
    Key? key,
    required this.enabled,
    required this.onToggle,
    required this.index,
    required this.birthDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ребёнок до 14 лет",
              style: context.textStyles.textLargeRegular(),
            ),
            AppSwitch(
              enabled: enabled,
              onToggle: (isEnabled) {
                onToggle.call(index, isEnabled);
              },
            ),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: 16),
          DatePickerField(
            initialDate: DateTime.now().subtract(days((365.25 * 14).toInt())),
            showingDate: birthDate,
            firstDate: DateTime.now().subtract(days((365.25 * 14).toInt())),
            lastDate: DateTime.now(),
            hint: "Дата рождения",
            onDateSelected: (dateTime) {
              onDateSelected(index, dateTime);
            },
          )
        ],
      ],
    );
  }
}
