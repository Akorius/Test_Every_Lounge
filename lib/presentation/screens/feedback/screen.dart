import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/feedback/widgets/feedback_buttons.dart';
import 'package:everylounge/presentation/screens/feedback/widgets/feedback_list.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsScreen extends StatelessWidget {
  static const String path = "contacts";

  const ContactsScreen({Key? key}) : super(key: key);
  static const number = "+74957950077";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colors.buttonPressed,
        title: Text(
          'Поддержка',
          style: context.textStyles.h1(color: context.colors.buttonPressedText),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                height: 250,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: context.colors.buttonPressed,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(26.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Есть вопросы? Свяжитесь с нами — мы будем рады помочь.',
                      style: context.textStyles.textLargeRegular(color: context.colors.buttonPressedText),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Поддержка работает круглосуточно 24/7',
                      style: AppTextStyles.textSmallRegular(color: context.colors.buttonPressedText),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FeedbackButtons(
                      onTap: () async {
                        final whatsApp = Uri.parse("whatsapp://send?phone=$number&text=hello");
                        try {
                          await launchUrl(whatsApp);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Приложение WhatsApp не установлено на вашем устройстве."),
                            ),
                          );
                        }
                      },
                      leading: AppImages.whatsUp,
                      title: 'Написать WhatsApp',
                      trailing: Icon(Icons.arrow_forward, color: context.colors.buttonPressedText),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    FeedbackButtons(
                      onTap: () async {
                        launchUrl(Uri.parse("tel://$number"));
                      },
                      leading: AppImages.phone,
                      title: '+7 (495) 795-00-77',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Ответы на частые вопросы',
                  style: context.textStyles.h1(color: context.colors.buttonPressed),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const FeedbackList(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: RegularButton(
                  label: Text(
                    'Написать в поддержку',
                    style: context.textStyles.negativeButtonText(color: context.colors.buttonPressedText),
                  ),
                  onPressed: () {
                    context.push(AppRoutes.feedbackContacts);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
