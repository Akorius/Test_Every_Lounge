import 'package:everylounge/domain/entities/protobuf/order.pb.dart' as proto;
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/cupertino.dart';

enum OrderStatus {
  /// создан
  created,

  /// подтвержден
  confirmed,

  /// оплачен
  paid,

  /// исполнен
  completed,

  /// отменен
  cancelled,

  /// добавлена информация об оплате
  initPay,

  /// заказ оплачен, но оплата не подтверждена
  bankPaid,

  /// обслуживается
  visited,

  /// истек
  expired,

  ///отклонен
  rejected,
  unknown,
}

List<OrderStatus> finishedStatuses = [
  OrderStatus.completed,
  OrderStatus.cancelled,
  OrderStatus.expired,
];

List<OrderStatus> toShowUpgradeStatusesInHistory = [
  OrderStatus.created,
  OrderStatus.confirmed,
  OrderStatus.initPay,
  OrderStatus.bankPaid,
  OrderStatus.paid,
  OrderStatus.visited,
  OrderStatus.completed,
  OrderStatus.cancelled,
];

List<OrderStatus> toShowOrderStatusesInActive = [
  OrderStatus.created,
  OrderStatus.confirmed,
  OrderStatus.initPay,
  OrderStatus.bankPaid,
  OrderStatus.paid,
];

List<proto.OrderStatus> finishedStatusesProto = [
  proto.OrderStatus.Completed,
  proto.OrderStatus.Cancelled,
  proto.OrderStatus.Expired,
];

List<OrderStatus> toShowShareContentStatuses = [
  OrderStatus.paid,
  OrderStatus.completed,
  OrderStatus.bankPaid,
  OrderStatus.visited,
  OrderStatus.unknown,
  OrderStatus.expired
];

extension OrderExtension on OrderStatus {
  static OrderStatus fromInt(int number) {
    switch (number) {
      case 0:
        return OrderStatus.created;
      case 1:
        return OrderStatus.confirmed;
      case 2:
        return OrderStatus.paid;
      case 3:
        return OrderStatus.completed;
      case 4:
        return OrderStatus.cancelled;
      case 5:
        return OrderStatus.initPay;
      case 6:
        return OrderStatus.bankPaid;
      case 7:
        return OrderStatus.visited;
      case 8:
        return OrderStatus.expired;
      case 9:
        return OrderStatus.rejected;
      default:
        return OrderStatus.unknown;
    }
  }
}

extension OrderNameExtension on OrderStatus {
  String getDesignation() {
    switch (this) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.initPay:
      case OrderStatus.bankPaid:
        return "Новый";
      case OrderStatus.paid:
        return "Оформлен";
      case OrderStatus.completed:
        return "Использован";
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return "Отменен";
      case OrderStatus.visited:
        return "Обслуживается";
      case OrderStatus.expired:
        return "Истек срок действия";
      default:
        return "Неопределенный";
    }
  }

  bool needMaskedPnr() {
    switch (this) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.initPay:
      case OrderStatus.bankPaid:
      case OrderStatus.cancelled:
        return true;
      case OrderStatus.paid:
      case OrderStatus.completed:
      case OrderStatus.visited:
      case OrderStatus.expired:
      default:
        return false;
    }
  }

  String getDesignationUpgrade() {
    switch (this) {
      case OrderStatus.created:
      case OrderStatus.confirmed:
      case OrderStatus.initPay:
        return "Новый";
      case OrderStatus.bankPaid:
      case OrderStatus.paid:
        return "Платёж принят, ожидает подтверждения";
      case OrderStatus.completed:
      case OrderStatus.visited:
        return "Подтверждено авиакомпанией";
      case OrderStatus.cancelled:
        return "Отклонено авиакомпанией";
      default:
        return "";
    }
  }

  Color getStatusColor(BuildContext context) {
    switch (this) {
      case OrderStatus.created:
        return context.colors.created;
      case OrderStatus.confirmed:
        return context.colors.confirmed;
      case OrderStatus.paid:
        return context.colors.paid;
      case OrderStatus.completed:
        return context.colors.completed;
      case OrderStatus.cancelled:
      case OrderStatus.rejected:
        return context.colors.cancelled;
      case OrderStatus.initPay:
        return context.colors.initPay;
      case OrderStatus.bankPaid:
        return context.colors.bankPaid;
      case OrderStatus.visited:
        return context.colors.visited;
      case OrderStatus.expired:
        return context.colors.expired;
      default:
        return context.colors.defaultStatus;
    }
  }

  Color getStatusColorUpgrade(BuildContext context) {
    switch (this) {
      case OrderStatus.created:
        return context.colors.created;
      case OrderStatus.confirmed:
        return context.colors.confirmed;
      case OrderStatus.initPay:
        return context.colors.initPay;
      case OrderStatus.paid:
      case OrderStatus.bankPaid:
        return context.colors.upgradePaidStatus;
      case OrderStatus.completed:
      case OrderStatus.visited:
        return context.colors.upgradeCompleteStatus;
      case OrderStatus.cancelled:
        return context.colors.upgradeCancelledStatus;
      default:
        return context.colors.defaultStatus;
    }
  }
}
