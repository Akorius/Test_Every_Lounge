import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TinkoffPayWebButtons extends StatefulWidget {
  const TinkoffPayWebButtons({Key? key}) : super(key: key);

  @override
  State<TinkoffPayWebButtons> createState() => _TinkoffPayWebButtonsState();
}

class _TinkoffPayWebButtonsState extends State<TinkoffPayWebButtons> {
  late final IFrameElement _element;

  @override
  void initState() {
    _element = IFrameElement()
      ..width = '500'
      ..height = '500'
      ..srcdoc = '''
<style>
    .tinkoffPayRow {
        display: block;
        margin: 1%;
        width: 160px;
    }
</style>
<link rel="stylesheet" href="https://securepay.tinkoff.ru/html/payForm/static/css/t-widget.css" type="text/css" />
<script src="https://securepay.tinkoff.ru/html/payForm/js/tinkoff_v2.js"></script>
<form name="TinkoffPayForm">
    <input class="tinkoffPayRow" type="hidden" name="terminalkey" value="1657195499055" />
    <input class="tinkoffPayRow" type="hidden" name="frame" value="false" />
    <input class="tinkoffPayRow" type="hidden" name="language" value="ru" />
    <input class="tinkoffPayRow" type="text" name="amount" value="2000" />
    <input class="tinkoffPayRow" type="hidden" name="order" value="testoviyweb200000" />
    <input class="tinkoffPayRow" type="hidden" name="description" value="Описание" />
    <input class="tinkoffPayRow" type="hidden" placeholder="ФИО плательщика" name="name" value="Важенин Андрей Александрович" />
    <input class="tinkoffPayRow" type="hidden" placeholder="E-mail" name="email" value="vazh2100@list.ru" />
    <input class="tinkoffPayRow" type="hidden" placeholder="Контактный телефон" name="phone" value="+79515099586" />
    <input class="tinkoffPayRow" type="hidden" name="receipt" value="" />
    <input class="tinkoffPayRow" type="hidden" name="customerKey" value="customerkey1111" />
    <input class="tinkoffPayRow" type="button" onclick="tinkoffPayFunction(this)" value="Оплатить" />
</form>
<script type="text/javascript">
    function tinkoffPayFunction(target) {
        let form = target.parentElement;
        let name = form.description.value || "Оплата";
        let amount = form.amount.value;
        let email = form.email.value;
        let phone = form.phone.value;

        if (amount && email && phone) {
            form.receipt.value = JSON.stringify({
                Email: email,
                Phone: phone,
                Taxation: "usn_income_outcome",
                Items: [
                    {
                        Name: name,
                        Price: amount + "00",
                        Quantity: 1.0,
                        Amount: amount + "00",
                        PaymentMethod: "full_payment",
                        PaymentObject: "service",
                        Tax: "none",
                    },
                ],
            });
            pay(form);
        } else alert("Не все обязательные поля заполнены");
        return false;
    }
</script>
<script type="text/javascript">
    const terminalkey = document.forms.TinkoffPayForm.terminalkey;
    const widgetParameters = {
        container: "tinkoffWidgetContainer",
        terminalKey: terminalkey.value,
        paymentSystems: {
            TinkoffPay: {
                paymentInfo: function () {
                    return {
                        infoEmail: "vazheninwork@gmail.com",
                        paymentData: document.forms.TinkoffPayForm,
                    };
                },
            },
        },
    };
    window.addEventListener("load", function () {
        initPayments(widgetParameters);
    });
</script>
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
