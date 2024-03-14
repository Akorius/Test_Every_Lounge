import 'package:easy_debounce/easy_debounce.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchBarWidget extends StatefulWidget {
  final EdgeInsets? padding;
  final String? hint;
  final Function(String) searchAirports;
  final Function onClearSearch;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const SearchBarWidget({
    required this.searchAirports,
    required this.onClearSearch,
    this.padding,
    this.hint,
    this.focusNode,
    this.controller,
    super.key,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.only(top: 24, bottom: 24),
      child: SizedBox(
        height: 48,
        child: TextField(
          focusNode: widget.focusNode,
          onTap: () => {},
          autofocus: false,
          controller: widget.controller ?? _controller,
          style: const TextStyle(
            height: 1.5,
          ),
          decoration: getDecoration(context),
          onChanged: _apply,
        ),
      ),
    );
  }

  InputDecoration getDecoration(BuildContext context) {
    var borderRadius = BorderRadius.circular(8);
    if (widget.focusNode != null && widget.focusNode?.hasFocus == true) {
      borderRadius = const BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0));
    }
    final border = OutlineInputBorder(
      borderSide: BorderSide(color: context.colors.searchBorder, width: 1),
      borderRadius: borderRadius,
    );
    final iconPadding = (widget.controller ?? _controller).text.isNotEmpty
        ? const EdgeInsets.only(right: 20, top: 16, bottom: 16)
        : const EdgeInsets.only(right: 19, top: 14, bottom: 14);
    final decoration = InputDecoration(
      hintStyle: context.textStyles.regularHintText(color: context.colors.hintText),
      fillColor: context.colors.searchBackground,
      filled: true,
      isDense: false,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      enabledBorder: border,
      focusedBorder: border,
      hintText: widget.hint ?? "Город, аэропорт или код аэропорта",
      counterStyle: context.textStyles.textLargeRegular(),
      suffixIcon: CupertinoButton(
        padding: iconPadding,
        borderRadius: BorderRadius.zero,
        color: Colors.transparent,
        onPressed: () {
          _clearSearchText();
        },
        child: SvgPicture.asset(
          (widget.controller ?? _controller).text.isNotEmpty ? AppImages.clearText : AppImages.search,
          color: context.colors.searchIcon,
        ),
      ),
    );
    return decoration;
  }

  void _apply(String value) {
    final trimmedValue = value.trim();
    setState(() {});
    if (trimmedValue.isNotEmpty) {
      widget.searchAirports(trimmedValue);
    } else {
      EasyDebounce.cancel("searchAirports");
      widget.onClearSearch();
    }
  }

  void _clearSearchText() {
    setState(() {
      _controller.clear();
    });
    widget.onClearSearch();
  }
}
