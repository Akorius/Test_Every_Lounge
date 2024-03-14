import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/create_order_premium/widget/cupertino_picker.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? showingDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? hint;
  final Function(DateTime) onDateSelected;

  const DatePickerField({
    Key? key,
    required this.initialDate,
    this.showingDate,
    required this.firstDate,
    required this.lastDate,
    this.hint,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    if (widget.showingDate != null) {
      _controller.text = DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, "ru").format(widget.showingDate!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (PlatformWrap.isAndroidOrWeb) {
          showDatePicker(
            context: context,
            initialDate: widget.initialDate,
            firstDate: widget.firstDate,
            lastDate: widget.lastDate,
            builder: (BuildContext context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  datePickerTheme: DatePickerThemeData(
                      headerBackgroundColor: context.colors.bottomSheetBackgroundColor,
                      headerForegroundColor: context.colors.textDefault,
                      headerHeadlineStyle: TextStyle(color: context.colors.textLight)),
                  colorScheme: ColorScheme.light(
                    primary: context.colors.avatarBackgroundColor,
                    onPrimary: context.colors.textLight,
                  ),
                  dialogTheme: DialogTheme(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                  ),
                ),
                child: child!,
              );
            },
          ).then(
            (value) => {
              setState(() {
                if (value != null) {
                  _controller.text = DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, "ru").format(value);
                  widget.onDateSelected(value);
                }
              })
            },
          );
        } else {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (_) {
              return IOSPickers(
                widget.firstDate,
                widget.lastDate,
                isTimePicker: false,
                onDateTimeChanged: (DateTime value) {
                  setState(
                    () {
                      _controller.text = DateFormat(DateFormat.YEAR_NUM_MONTH_DAY, "ru").format(value);
                      widget.onDateSelected(value);
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
            AppImages.calendar,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
