import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:flutter/cupertino.dart';

class PayOrderState extends Equatable {
  final bool loading;
  final bool isPayByCardLoading;
  final Uri? webViewPaymentUri;
  final Order? order;

  const PayOrderState({
    this.loading = false,
    this.isPayByCardLoading = false,
    this.webViewPaymentUri,
    this.order,
  });

  @override
  List<Object?> get props => [
        loading,
        isPayByCardLoading,
        webViewPaymentUri,
        order,
      ];

  static const String navigateToTinkoffWebView = "navigateToTinkoffWebView";
  static const String navigateToSuccess = "navigateToSuccess";
  static const String navigateToOrderDetailsScreen = "navigateToOrderDetailsScreen";

  PayOrderState copyWith({
    bool? loading,
    bool? isPayByCardLoading,
    ValueGetter<Uri?>? webViewPaymentUri,
    Order? order,
  }) {
    return PayOrderState(
        loading: loading ?? this.loading,
        isPayByCardLoading: isPayByCardLoading ?? this.isPayByCardLoading,
        webViewPaymentUri: webViewPaymentUri != null ? webViewPaymentUri() : this.webViewPaymentUri,
        order: order ?? this.order);
  }
}
