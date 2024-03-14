import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/feedback/cubit.dart';
import 'package:everylounge/presentation/screens/feedback/widgets/question_answer_item.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackList extends StatelessWidget {
  const FeedbackList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedbackCubit, FeedbackState>(
      builder: (context, state) {
        return (!state.isLoading)
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: context.colors.buttonPressedText,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return QuestionAnswerItem(
                        title: state.faq![index].question,
                        bodyText: state.faq![index].answer,
                        isExpanded: state.buttons[index],
                        onTap: () {
                          context.read<FeedbackCubit>().onAnswerTaped(index);
                        });
                  },
                  separatorBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        color: context.colors.buttonDisabled,
                      ),
                    );
                  },
                  itemCount: state.buttons.length,
                ),
              )
            : const Center(
                child: AppCircularProgressIndicator(),
              );
      },
    );
  }
}
