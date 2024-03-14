import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/file/pdf_data.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/screens/login_flow/other_login/cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class TermOfUse extends StatelessWidget {
  const TermOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: context.textStyles.textNormalRegularGrey(),
      textAlign: TextAlign.center,
      TextSpan(
        text: "Нажимая «Продолжить» или кнопки авторизации одним из способов, вы соглашаетесь\nс",
        children: [
          const TextSpan(text: ' '),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.read<OtherLoginCubit>().sendEvent(eventName[rulesDownloadClick]!);
                final String link = context.read<OtherLoginCubit>().getLink(0);
                context.push(AppRoutes.pdfViewScreen, extra: PdfData(title: "Правила программы", link: link));
              },
            text: "Правилами программы",
            style: context.textStyles.textNormalRegularLink(),
          ),
          const TextSpan(text: ', '),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.read<OtherLoginCubit>().sendEvent(eventName[contractDownloadClick]!);
                final String link = context.read<OtherLoginCubit>().getLink(2);
                context.push(AppRoutes.pdfViewScreen, extra: PdfData(title: "Договор оферты", link: link));
              },
            text: "Договором оферты\n",
            style: context.textStyles.textNormalRegularLink(),
          ),
          const TextSpan(text: ' и даете согласие на обработку персональных данных'),
        ],
      ),
    );
  }
}
