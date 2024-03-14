import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/feedback/cubit.dart';
import 'package:everylounge/presentation/screens/feedback/widgets/app_bar.dart';
import 'package:everylounge/presentation/widgets/inputs/default_text_field.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FeedbackContacts extends StatefulWidget {
  static const String path = "feedback";

  const FeedbackContacts({Key? key}) : super(key: key);

  @override
  State<FeedbackContacts> createState() => _FeedbackContactsState();
}

class _FeedbackContactsState extends State<FeedbackContacts> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController mail = TextEditingController();

  void fillData(FeedbackState feedbackState) {
    if (!feedbackState.isLoading && feedbackState.user != null) {
      email.text = feedbackState.user!.email;
      name.text = feedbackState.user!.profile.firstName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FeedbackAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: BlocBuilder<FeedbackCubit, FeedbackState>(
          builder: (context, state) {
            if (email.text == '') {
              fillData(state);
            }
            return !state.isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'О чем вы хотите сообщить?',
                          style: context.textStyles.negativeButtonText(
                            color: context.colors.buttonPressed,
                          ),
                        ),
                      ),
                      DefaultTextField(
                        controller: name,
                        keyboardType: TextInputType.name,
                        onChanged: (String newName) {
                          name.text = newName;
                          name.selection = TextSelection.fromPosition(TextPosition(offset: name.text.length));
                          context.read<FeedbackCubit>().checkFiledData(
                                name: name.text,
                                email: email.text,
                                text: mail.text,
                              );
                        },
                        hint: 'Ваше имя',
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DefaultTextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        errorText: state.emailError,
                        onChanged: (String newEmail) {
                          email.text = newEmail;
                          email.selection = TextSelection.fromPosition(TextPosition(offset: email.text.length));
                          context.read<FeedbackCubit>().checkFiledData(
                                name: name.text,
                                email: email.text,
                                text: mail.text,
                              );
                        },
                        hint: 'Ваш email',
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DefaultTextField(
                        keyboardType: TextInputType.text,
                        controller: mail,
                        onChanged: (String text) {
                          mail.text = text;
                          mail.selection = TextSelection.fromPosition(TextPosition(offset: mail.text.length));
                          context.read<FeedbackCubit>().checkFiledData(
                                name: name.text,
                                email: email.text,
                                text: mail.text,
                              );
                        },
                        hint: 'Ваше сообщение',
                        maxLines: 5,
                      ),
                      const Spacer(),
                      RegularButton(
                        label: Text(
                          'Отправить',
                          style: context.textStyles.negativeButtonText(color: context.colors.buttonDisabledText),
                        ),
                        onPressed: () async {
                          bool result = await context.read<FeedbackCubit>().postFeedback(
                                name: name.text,
                                email: email.text,
                                text: mail.text,
                              );
                          if (result) {
                            await context.push(AppRoutes.successSendFeedbackModal);
                            name.clear();
                            email.clear();
                            mail.clear();
                            context.pop();
                          }
                        },
                        canPress: state.canPress!,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  )
                : const Center(child: AppCircularProgressIndicator.large());
          },
        ),
      ),
    );
  }
}
