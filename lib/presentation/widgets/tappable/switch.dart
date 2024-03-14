import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AppSwitch extends StatefulWidget {
  final bool enabled;
  final Function(bool) onToggle;

  const AppSwitch({
    Key? key,
    required this.enabled,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<AppSwitch> createState() => _AppSwitchState();
}

class _AppSwitchState extends State<AppSwitch> {
  bool enabled = false;

  @override
  void initState() {
    enabled = widget.enabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: enabled,
      onToggle: (bool enabled) {
        setState(() {
          this.enabled = enabled;
        });
        widget.onToggle(this.enabled);
      },
      height: 24,
      width: 39,
      toggleSize: 18,
      borderRadius: 75,
      padding: 3,
      activeColor: context.colors.buttonEnabled,
      inactiveColor: context.colors.buttonDisabled,
    );
  }
}
