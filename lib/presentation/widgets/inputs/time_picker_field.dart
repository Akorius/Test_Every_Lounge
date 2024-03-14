import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/cupertino_picker.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimePickerField extends StatefulWidget {
  final String? hint;
  final Function(TimeOfDay) onTimeSelected;

  const TimePickerField({
    Key? key,
    this.hint,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (PlatformWrap.isAndroidOrWeb) {
          showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (BuildContext context, child) {
              return Theme(
                  data: Theme.of(context).copyWith(
                    timePickerTheme: TimePickerThemeData(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                    colorScheme: ColorScheme.light(
                      primary: context.colors.avatarBackgroundColor,
                    ),
                  ),
                  child: MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1), child: child!));
            },
          ).then(
            (value) => {
              setState(() {
                if (value != null) {
                  _controller.text = value.format(context);
                  widget.onTimeSelected(value);
                }
              })
            },
          );
        } else {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (_) {
              return IOSPickers(
                DateTime.now(),
                DateTime.now(),
                isTimePicker: true,
                onDateTimeChanged: (DateTime value) {
                  setState(
                    () {
                      _controller.text = TimeOfDay.fromDateTime(value).format(context);
                      widget.onTimeSelected(TimeOfDay.fromDateTime(value));
                    },
                  );
                },
              );
            },
          );
        }
      },
      child: DefaultTextField(
        hint: widget.hint,
        enabled: false,
        controller: _controller,
        keyboardType: TextInputType.datetime,
        onChanged: (text) {},
        suffixIcon: Container(
          alignment: Alignment.center,
          width: 5,
          child: SvgPicture.asset(
            AppImages.clock2,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
