//
//  Generated code. Do not modify.
//  source: order.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AcquiringType extends $pb.ProtobufEnum {
  static const AcquiringType Unknown = AcquiringType._(0, _omitEnumNames ? '' : 'Unknown');
  static const AcquiringType Passages = AcquiringType._(1, _omitEnumNames ? '' : 'Passages');
  static const AcquiringType Tinkoff = AcquiringType._(2, _omitEnumNames ? '' : 'Tinkoff');
  static const AcquiringType Alfa = AcquiringType._(3, _omitEnumNames ? '' : 'Alfa');

  static const $core.List<AcquiringType> values = <AcquiringType> [
    Unknown,
    Passages,
    Tinkoff,
    Alfa,
  ];

  static final $core.Map<$core.int, AcquiringType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AcquiringType? valueOf($core.int value) => _byValue[value];

  const AcquiringType._($core.int v, $core.String n) : super(v, n);
}

class OrderStatus extends $pb.ProtobufEnum {
  static const OrderStatus Created = OrderStatus._(0, _omitEnumNames ? '' : 'Created');
  static const OrderStatus Confirmed = OrderStatus._(1, _omitEnumNames ? '' : 'Confirmed');
  static const OrderStatus Paid = OrderStatus._(2, _omitEnumNames ? '' : 'Paid');
  static const OrderStatus Completed = OrderStatus._(3, _omitEnumNames ? '' : 'Completed');
  static const OrderStatus Cancelled = OrderStatus._(4, _omitEnumNames ? '' : 'Cancelled');
  static const OrderStatus InitPay = OrderStatus._(5, _omitEnumNames ? '' : 'InitPay');
  static const OrderStatus BankPaid = OrderStatus._(6, _omitEnumNames ? '' : 'BankPaid');
  static const OrderStatus Visited = OrderStatus._(7, _omitEnumNames ? '' : 'Visited');
  static const OrderStatus Expired = OrderStatus._(8, _omitEnumNames ? '' : 'Expired');

  static const $core.List<OrderStatus> values = <OrderStatus> [
    Created,
    Confirmed,
    Paid,
    Completed,
    Cancelled,
    InitPay,
    BankPaid,
    Visited,
    Expired,
  ];

  static final $core.Map<$core.int, OrderStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OrderStatus? valueOf($core.int value) => _byValue[value];

  const OrderStatus._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
