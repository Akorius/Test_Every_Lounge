import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/cubit.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateAppScreen extends StatelessWidget {
  static const path = "updateAppScreen";

  const UpdateAppScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 40),
        child: RegularButton(
          label: const Text("Обновить"),
          onPressed: () {
            context.read<HomeBottomNavigationCubit>().updateApp();
          },
          withoutElevation: true,
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(AppImages.updateAppRequired),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 73),
                child: Text(
                  textAlign: TextAlign.center,
                  "Новая версия Every Lounge",
                  style: context.textStyles.h2(color: context.colors.textDefault),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                child: Text(
                  "Для стабильной работы необходимо обновить приложение",
                  textAlign: TextAlign.center,
                  style: context.textStyles.textLargeRegular(color: context.colors.textDefault),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
