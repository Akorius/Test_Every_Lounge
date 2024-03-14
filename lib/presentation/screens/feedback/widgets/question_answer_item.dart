import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class QuestionAnswerItem extends StatefulWidget {
  final String title;
  final String? bodyText;
  final bool isExpanded;
  final Function onTap;
  final RichText? richText;

  const QuestionAnswerItem({
    Key? key,
    required this.title,
    this.bodyText,
    required this.isExpanded,
    required this.onTap,
    this.richText,
  })  : assert(bodyText == null || richText == null, "bodyText or richText must be provided"),
        super(key: key);

  @override
  State<QuestionAnswerItem> createState() => _QuestionAnswerItemState();
}

class _QuestionAnswerItemState extends State<QuestionAnswerItem> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              widget.onTap();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: context.textStyles.negativeButtonText(color: context.colors.buttonPressed),
                  ),
                ),
                const SizedBox(width: 30),
                AnimatedRotation(
                    turns: widget.isExpanded ? 0.0 : -0.5,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_up_outlined, color: context.colors.buttonPressed)),
              ],
            ),
          ),
          SizeTransition(
              sizeFactor: _controller,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: widget.richText ??
                    Text(
                      widget.bodyText!,
                      style: AppTextStyles.textSmallRegular(color: context.colors.appBarBackArrowColor),
                    ),
              )),
        ],
      ),
    );
  }
}
