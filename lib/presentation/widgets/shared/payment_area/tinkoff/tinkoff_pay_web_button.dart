import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TinkoffPayWebButton extends StatefulWidget {
  const TinkoffPayWebButton({Key? key}) : super(key: key);

  @override
  State<TinkoffPayWebButton> createState() => _TinkoffPayWebButtonState();
}

class _TinkoffPayWebButtonState extends State<TinkoffPayWebButton> {
  late final IFrameElement _element;

  @override
  void initState() {
    _element = IFrameElement()
      ..width = '500'
      ..height = '500'
      ..srcdoc = '''
<link rel="stylesheet" href="https://securepay.tinkoff.ru/tpaytid/styles.css" media="print" onload="this.media='all'" />
<tinkoff-pay-id-button terminalkey="1657195499055" redirectsuccess="false" rederectfail="false"></tinkoff-pay-id-button>
<script src="https://securepay.tinkoff.ru/tpaytid/tinkoff-pay-button.js" type="module"></script>
        ''';

    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'TinkoffPay',
      (int viewId) => _element,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      width: 500,
      child: HtmlElementView(
        viewType: 'TinkoffPay',
      ),
    );
  }
}
