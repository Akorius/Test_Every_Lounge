import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

showChangeDataDialog(
  BuildContext context, {
  required Function() onPressed,
  required TextEditingController? controller,
  required String? title,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text("Введите ${(title == 'Фамилия') ? "фамилию" : title!.toLowerCase()}"),
        content: BlocProvider<ProfileSettingsCubit>(
          create: (context) => getIt(),
          child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
            builder: (context, state) {
              return SizedBox(
                height: 50,
                child: DefaultTextField(
                  controller: controller!,
                  keyboardType: TextInputType.emailAddress,
                  errorText: state.passwordError,
                  onChanged: (text) => {},
                  hint: title,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Отмена"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text("Сохранить"),
            onPressed: () {
              onPressed();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
