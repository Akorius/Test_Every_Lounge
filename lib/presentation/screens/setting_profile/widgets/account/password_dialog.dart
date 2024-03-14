import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/presentation/common/storage/storage.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:launch_app_store/launch_app_store.dart';

showAlertDialog(
  BuildContext context, {
  required bool isRating,
  Function(String)? onSubmitted,
  Function(String)? onChanged,
  TextEditingController? controller,
}) {
  Widget okButton = StatefulBuilder(builder: (context, StateSetter setState) {
    return TextButton(
      child: const Text("OK"),
      onPressed: () async {
        await LaunchReview.launch(androidAppId: AppStorage.rateAndroidId, iOSAppId: AppStorage.rateIOSId);
        Navigator.pop(context);
      },
    );
  });

  AlertDialog ratingDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    title: const Text("Оставьте отзыв"),
    content: RatingBar.builder(
      minRating: 1,
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemSize: MediaQuery.of(context).size.width * 0.1,
      onRatingUpdate: (rating) {},
    ),
    actions: [
      okButton,
    ],
  );

  AlertDialog passwordDialog = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    title: const Text("Введите пароль"),
    content: BlocProvider<ProfileSettingsCubit>(
      create: (context) => getIt(),
      child: BlocBuilder<ProfileSettingsCubit, ProfileSettingsState>(
        builder: (context, state) {
          return SizedBox(
            height: 70,
            child: DefaultTextField(
              controller: controller!,
              keyboardType: TextInputType.emailAddress,
              errorText: state.passwordError,
              onChanged: onChanged!,
              onSubmitted: onSubmitted,
              hint: 'Пароль',
            ),
          );
        },
      ),
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return isRating ? ratingDialog : passwordDialog;
    },
  );
}
